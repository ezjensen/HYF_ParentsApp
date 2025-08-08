//
//  FieldLocationsView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 8/8/25.
//

import SwiftUI

struct FieldLocationsView: View {
	@StateObject private var fieldService = FieldService()
	@State private var searchText = ""
	@State private var selectedField: Field? = nil
	
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
	
	var body: some View {
		ZStack {
			// Background
			Color.black.ignoresSafeArea()
			
			// Content
			VStack(spacing: 0) {
				// Search field
				HStack {
					Image(systemName: "magnifyingglass")
						.foregroundColor(.gray)
					TextField("Search fields...", text: $searchText)
						.foregroundColor(.white)
					
					if !searchText.isEmpty {
						Button(action: {
							searchText = ""
						}) {
							Image(systemName: "xmark.circle.fill")
								.foregroundColor(.gray)
						}
					}
				}
				.padding()
				.background(Color(UIColor.darkGray).opacity(0.3))
				.cornerRadius(10)
				.padding()
				
				// Field list
				if fieldService.isLoading {
					Spacer()
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle(tint: .white))
						.scaleEffect(1.5)
					Spacer()
				} else if filteredFields.isEmpty {
					Spacer()
					Text("No fields matching '\(searchText)'")
						.foregroundColor(.gray)
						.padding()
					Spacer()
				} else {
					ScrollView {
						LazyVStack(spacing: 16) {
							ForEach(filteredFields) { field in
								FieldRowView(field: field)
									.onTapGesture {
										selectedField = field
									}
							}
						}
						.padding(.horizontal)
						.padding(.vertical, 8)
					}
				}
			}
		}
		.onAppear {
			fieldService.fetchFields()
		}
		.sheet(item: $selectedField) { field in
			FieldDetailView(field: field)
		}
	}
}

struct FieldRowView: View {
	let field: Field
	
	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 6) {
				Text(field.name)
					.font(.headline)
					.foregroundColor(.white)
				
				Text(field.address)
					.font(.subheadline)
					.foregroundColor(.gray)
					.lineLimit(1)
			}
			
			Spacer()
			
			if field.is_home_field {
				Image("HYF_Bandito")
					.resizable()
					.scaledToFit()
					.frame(width: 40, height: 40)
			}
		}
		.padding()
		.background(Color(UIColor.darkGray).opacity(0.3))
		.cornerRadius(10)
	}
}

struct FieldDetailView: View {
	let field: Field
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color.black.ignoresSafeArea()
				
				ScrollView {
					VStack(alignment: .leading, spacing: 20) {
						if field.is_home_field {
							HStack {
								Spacer()
								Image("HYF_Bandito")
									.resizable()
									.scaledToFit()
									.frame(height: 120)
								Spacer()
							}
							.padding(.top, 20)
						}
						
						Text(field.name)
							.font(.largeTitle)
							.fontWeight(.bold)
							.foregroundColor(.white)
						
						Button(action: {
							openInMaps(address: field.address)
						}) {
							VStack(alignment: .leading) {
								Text("Address:")
									.font(.headline)
									.foregroundColor(.gray)
								
								HStack {
									Text(field.address)
										.font(.title3)
										.foregroundColor(.white)
									
									Spacer()
									
									Image(systemName: "map.fill") // Changed from arrow.up.right.square to map.fill
										.foregroundColor(.red)
								}
							}
							.padding()
							.background(Color(UIColor.darkGray).opacity(0.3))
							.cornerRadius(10)
						}
						
						if let notes = field.notes, !notes.isEmpty {
							VStack(alignment: .leading) {
								Text("Notes:")
									.font(.headline)
									.foregroundColor(.gray)
								
								Text(notes)
									.foregroundColor(.white)
									.fixedSize(horizontal: false, vertical: true) // Allow vertical growth
									.lineLimit(nil) // Allow multiple lines
									.multilineTextAlignment(.leading) // Align text to the left
							}
							.padding()
							.frame(maxWidth: .infinity, alignment: .leading) // Full width container
							.background(Color(UIColor.darkGray).opacity(0.3))
							.cornerRadius(10)
						}
						
						if field.is_home_field {
							HStack {
								Spacer()
								Text("HOME FIELD")
									.font(.headline)
									.foregroundColor(.red)
									.padding(.horizontal, 16)
									.padding(.vertical, 8)
									.overlay(
										RoundedRectangle(cornerRadius: 8)
											.stroke(Color.red, lineWidth: 2)
									)
								Spacer()
							}
							.padding(.top, 10)
						}
						
						Spacer()
					}
					.padding()
				}
			}
			.navigationTitle("Field Details")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Done") {
						dismiss()
					}
				}
			}
		}
		.accentColor(.red)
	}
	
	private func openInMaps(address: String) {
		if let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
		   let url = URL(string: "https://maps.apple.com/?q=\(encodedAddress)") {
			UIApplication.shared.open(url)
		}
	}
}
