//
//  FieldLocationsView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 8/8/25.
//

import SwiftUI
import MapKit

// Define IdentifiablePlace at the top level
struct IdentifiablePlace: Identifiable {
	let id: String
	let coordinate: CLLocationCoordinate2D
}

struct FieldLocationsView: View {
	// Use the shared singleton instead of creating a new instance
	@EnvironmentObject private var fieldService: FieldService
	@State private var searchText = ""
	@State private var selectedField: Field?
	
	var body: some View {
		VStack {
			// Search box with conditional red border
			TextField("Search fields...", text: $searchText)
				.padding()
				.background(.ultraThinMaterial)
				.cornerRadius(8)
				.padding(.horizontal)
				.foregroundColor(fieldService.isDataFromSupabase ? nil : .red)
			
			if fieldService.isLoading {
				Spacer()
				ProgressView("Loading fields...")
				Spacer()
			} else {
				List(filteredFields) { field in
					Button {
						selectedField = field
					} label: {
						FieldRowView(field: field)
					}
					.buttonStyle(PlainButtonStyle())
				}
			}
		}
		.navigationTitle("Field Locations")
		.sheet(item: $selectedField) { field in
			NavigationStack {
				FieldDetailView(field: field)
					.navigationBarItems(trailing: Button("Done") {
						selectedField = nil
					})
					.navigationBarTitle("Field Details", displayMode: .inline)
			}
			.accentColor(.red)
		}
	}
	
	var filteredFields: [Field] {
		if searchText.isEmpty {
			return fieldService.fields
		} else {
			return fieldService.fields.filter { field in
				field.name.localizedCaseInsensitiveContains(searchText) ||
				field.address.localizedCaseInsensitiveContains(searchText)
			}
		}
	}
}

// MARK: - FieldRowView
struct FieldRowView: View {
	let field: Field
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(field.name)
				.font(.headline)
			
			Text(field.address)
				.font(.subheadline)
				.foregroundColor(.gray)
			
			if field.is_home_field {
				Text("Home Field")
					.font(.caption)
					.foregroundColor(.red)
					.padding(.top, 2)
			}
		}
		.padding(.vertical, 4)
	}
}

// MARK: - FieldDetailView
struct FieldDetailView: View {
	let field: Field
	@State private var position: MapCameraPosition = .automatic
	@State private var locationAnnotation: IdentifiablePlace?
	@State private var isLoadingLocation = true
	@State private var geocodingError = false
	@State private var viewId = UUID()
	@State private var isShowingShareSheet = false
	
	var body: some View {
		VStack {
			ZStack {
				// Using the new Map initializer syntax for iOS 17+
				if #available(iOS 17.0, *) {
					Map(position: $position) {
						if let location = locationAnnotation {
							Marker(field.name, coordinate: location.coordinate)
						}
					}
					.id(viewId)
					.frame(height: 300)
				} else {
					// Fallback for iOS 16 and earlier
					if let location = locationAnnotation {
						Map(coordinateRegion: .constant(MKCoordinateRegion(
							center: location.coordinate,
							span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
						)))
						.id(viewId)
						.frame(height: 300)
					} else {
						Color.gray.opacity(0.2)
							.frame(height: 300)
					}
				}
				
				if isLoadingLocation {
					Color.black.opacity(0.1)
					ProgressView()
				}
				
				if geocodingError {
					Text("Could not find location on map")
						.padding()
						.background(Color.black.opacity(0.7))
						.foregroundColor(.white)
						.cornerRadius(8)
				}
			}
			
			VStack(alignment: .leading, spacing: 12) {
				HStack {
					Text(field.name)
						.font(.title)
						.fontWeight(.bold)
					
					Spacer()
					
					Button(action: {
						isShowingShareSheet = true
					}) {
						Image(systemName: "square.and.arrow.up")
							.foregroundColor(.red)
							.font(.title2)
					}
				}
				
				Text(field.address)
					.font(.body)
				
				if field.is_home_field {
					Text("Home Field")
						.font(.headline)
						.foregroundColor(.red)
						.padding(.top, 2)
				}
				
				Divider()
				
				if let notes = field.notes, !notes.isEmpty {
					Text("Notes:")
						.font(.headline)
					
					Text(notes)
						.font(.body)
				}
				
				Spacer()
				
				Button(action: {
					openInMaps()
				}) {
					Label("Directions", systemImage: "map")
						.frame(maxWidth: .infinity)
				}
				.buttonStyle(.borderedProminent)
				.tint(.red)
				.disabled(locationAnnotation == nil)
			}
			.padding()
		}
		.onAppear {
			// Manually start geocoding when view appears
			geocodeAddress()
		}
		.sheet(isPresented: $isShowingShareSheet) {
			ShareSheet(items: shareItems)
		}
	}
	
	var shareItems: [Any] {
		// Create the content to share
		let fieldInfo = """
		Field: \(field.name)
		Address: \(field.address)
		\(field.notes != nil && !field.notes!.isEmpty ? "Notes: \(field.notes!)" : "")
		"""
		
		// Create URL for Google Maps if available
		var items: [Any] = [fieldInfo]
		if let locationAnnotation = locationAnnotation {
			let mapURL = "https://maps.google.com/maps?q=\(locationAnnotation.coordinate.latitude),\(locationAnnotation.coordinate.longitude)"
			if let url = URL(string: mapURL) {
				items.append(url)
			}
		}
		
		return items
	}
	
	func geocodeAddress() {
		// Reset state
		isLoadingLocation = true
		geocodingError = false
		locationAnnotation = nil
		viewId = UUID()
		
		print("Starting geocoding for: \(field.name) at \(field.address)")
		
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(field.address) { placemarks, error in
			// Always update UI on main thread
			DispatchQueue.main.async {
				self.isLoadingLocation = false
				
				if let error = error {
					print("Geocoding error for \(field.name): \(error.localizedDescription)")
					self.geocodingError = true
					return
				}
				
				guard let location = placemarks?.first?.location else {
					print("No location found for address: \(field.address)")
					self.geocodingError = true
					return
				}
				
				let coordinate = location.coordinate
				print("Successfully geocoded \(field.name): \(coordinate.latitude), \(coordinate.longitude)")
				
				// Create a unique annotation
				self.locationAnnotation = IdentifiablePlace(
					id: UUID().uuidString,
					coordinate: coordinate
				)
				
				// Update map position based on iOS version
				if #available(iOS 17.0, *) {
					self.position = .region(MKCoordinateRegion(
						center: coordinate,
						span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
					))
				}
				
				// Force view update
				self.viewId = UUID()
			}
		}
	}
	
	func openInMaps() {
		guard let locationAnnotation = locationAnnotation else { return }
		
		let coordinate = locationAnnotation.coordinate
		let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
		mapItem.name = field.name
		
		mapItem.openInMaps()
	}
}
