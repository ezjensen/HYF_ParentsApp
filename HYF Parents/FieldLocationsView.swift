//
//  FieldLocationsView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/18/25.
//

import SwiftUI
import MapKit

// MARK: - Field Details List View
struct FieldDetailsView: View {
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject private var fieldService: FieldService
	@State private var isLoading = true
	
	var body: some View {
		NavigationStack {
			if isLoading {
				ProgressView("Loading fields...")
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			} else if fieldService.fields.isEmpty {
				ContentUnavailableView(
					"No Fields Available",
					systemImage: "mappin.slash",
					description: Text("Field locations could not be loaded.")
				)
			} else {
				List(fieldService.fields) { field in
					NavigationLink(destination: FieldLocationsView(field: field)) {
						VStack(alignment: .leading, spacing: 8) {
							HStack {
								Text(field.name)
									.font(.headline)
									.fontWeight(.semibold)
								
								Spacer()
								
								if field.is_home_field {
									Image("HYF_H")
										.resizable()
										.aspectRatio(contentMode: .fit)
										.frame(width: 20, height: 20)
										.foregroundColor(.blue)
								}
							}
							
							Text(field.address)
								.font(.subheadline)
								.foregroundColor(.secondary)
								.lineLimit(2)
						}
						.padding(.vertical, 4)
					}
				}
			}
		}
		.navigationTitle("Field Locations")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button("Done") {
					dismiss()
				}
			}
		}
		.task {
			// loadFields is synchronous (it spawns its own Task) so don't await it
			fieldService.loadFields()
			isLoading = false
		}
	}
}

struct FieldLocationsView: View {
	let field: Field
	@State private var cameraPosition: MapCameraPosition
	
	init(field: Field) {
		self.field = field
		self._cameraPosition = State(initialValue: MapCameraPosition.region(
			MKCoordinateRegion(
				center: CLLocationCoordinate2D(latitude: 42.1667, longitude: -88.3087),
				span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
			)
		))
	}
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 24) {
				// Address Section with Home Field indicator on the same line
				VStack(alignment: .leading, spacing: 16) {
					HStack {
						HStack(spacing: 10) {
							Image(systemName: "location")
								.symbolRenderingMode(.hierarchical)
								.foregroundStyle(.blue.gradient)
							Text("Address")
								.font(.headline)
								.fontWeight(.semibold)
						}
						
						Spacer()
						
						if field.is_home_field {
							HStack(spacing: 8) {
								Image("HYF_H")
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(width: 18, height: 18)
									.foregroundColor(.blue)
								Text("Home Field")
									.font(.caption)
									.fontWeight(.semibold)
									.foregroundStyle(.blue)
							}
							.padding(.horizontal, 12)
							.padding(.vertical, 6)
							.background(.ultraThinMaterial, in: .capsule)
							.overlay(
								Capsule()
									.strokeBorder(.blue.opacity(0.3), lineWidth: 1)
							)
						}
					}
					
					Text(field.address)
						.font(.body)
						.foregroundStyle(.secondary)
						.textSelection(.enabled)
						.padding(.leading, 32)
				}
				.padding(20)
				.background(.thickMaterial, in: .rect(cornerRadius: 20))
				.overlay(
					RoundedRectangle(cornerRadius: 20)
						.strokeBorder(.quaternary.opacity(0.5), lineWidth: 0.5)
				)
				.padding(.horizontal, 20)
				
				// Map View
				VStack(spacing: 16) {
					HStack(spacing: 10) {
						Image(systemName: "map")
							.symbolRenderingMode(.hierarchical)
							.foregroundStyle(.green.gradient)
						Text("Field Location")
							.font(.headline)
							.fontWeight(.semibold)
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					
					Map(position: $cameraPosition) {
						Annotation(field.name, coordinate: CLLocationCoordinate2D(latitude: 42.1667, longitude: -88.3087)) {
							ZStack {
								Circle()
									.fill(.red.gradient)
									.frame(width: 32, height: 32)
								Image(systemName: "mappin")
									.foregroundStyle(.white)
									.font(.system(size: 16, weight: .bold))
							}
						}
					}
					.frame(minHeight: 250)
					.clipShape(.rect(cornerRadius: 20))
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.strokeBorder(.quaternary.opacity(0.3), lineWidth: 0.5)
					)
				}
				.padding(.horizontal, 20)
				
				// Directions Button
				Button(action: openDirections) {
					HStack(spacing: 12) {
						Image(systemName: "arrow.triangle.turn.up.right.diamond")
							.font(.system(size: 18, weight: .medium))
						Text("Get Directions")
							.font(.headline)
							.fontWeight(.semibold)
					}
					.frame(maxWidth: .infinity)
					.padding(.vertical, 18)
					.background(.blue.gradient, in: .capsule)
					.foregroundStyle(.white)
					.shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
				}
				.buttonStyle(.plain)
				.padding(.horizontal, 20)
				
				// Notes Section
				if let notes = field.notes, !notes.isEmpty {
					VStack(alignment: .leading, spacing: 16) {
						HStack(spacing: 10) {
							Image(systemName: "note.text")
								.symbolRenderingMode(.hierarchical)
								.foregroundStyle(.orange.gradient)
							Text("Notes")
								.font(.headline)
								.fontWeight(.semibold)
						}
						
						Text(notes)
							.font(.body)
							.foregroundStyle(.secondary)
							.textSelection(.enabled)
							.lineLimit(nil)
							.padding(.leading, 32)
					}
					.padding(20)
					.background(.thickMaterial, in: .rect(cornerRadius: 20))
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.strokeBorder(.quaternary.opacity(0.5), lineWidth: 0.5)
					)
					.padding(.horizontal, 20)
				}
				
				Spacer(minLength: 40)
			}
			.padding(.top, 20)
		}
		.navigationTitle(field.name)
		.navigationBarTitleDisplayMode(.inline)
		.toolbarBackground(.ultraThinMaterial, for: .navigationBar)
		.toolbarBackground(.visible, for: .navigationBar)
		.background(.regularMaterial)
	}
	
	private func openDirections() {
		let encodedAddress = field.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
		
		// Try Apple Maps first
		if let appleURL = URL(string: "http://maps.apple.com/?daddr=\(encodedAddress)") {
			if UIApplication.shared.canOpenURL(appleURL) {
				UIApplication.shared.open(appleURL)
				return
			}
		}
		
		// Fallback to Google Maps
		if let googleURL = URL(string: "https://maps.google.com/maps?daddr=\(encodedAddress)") {
			UIApplication.shared.open(googleURL)
		}
	}
}

#Preview {
	NavigationStack {
		FieldLocationsView(field: Field(id: 1, name: "Preview Field", address: "123 Test St", is_home_field: true, notes: "Test notes"))
	}
}
