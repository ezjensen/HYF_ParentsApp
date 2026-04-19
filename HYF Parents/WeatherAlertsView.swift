//
//  WeatherAlertsView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/15/25.
//

import SwiftUI
import WebKit

struct WeatherLocation: Identifiable, Codable {
	var id: Int // Changed from UUID to Int to match the database type
	var locationName: String
	var locationWeatherLink: String
	
	enum CodingKeys: String, CodingKey {
		case id
		case locationName
		case locationWeatherLink
	}
}

struct WeatherAlertsView: View {
	@Environment(\.openURL) var openURL
	@Binding var selectedTab: Int
	
	// For preview purposes
	init(selectedTab: Binding<Int> = .constant(4)) {
		self._selectedTab = selectedTab
	}
	
	@State private var selectedSchool = "Marlowe Middle School"
	@State private var weatherLocations: [WeatherLocation] = []
	@State private var isLoading = true
	@State private var errorMessage: String? = nil
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color.black.ignoresSafeArea()
				
				GeometryReader { geometry in
					ScrollView(.vertical, showsIndicators: false) {
						VStack(spacing: 0) {
							BannerView(geometry: geometry, selectedTab: $selectedTab)
								.padding(.top, 70) // Consistent with other views
							
							VStack(alignment: .leading, spacing: 5) {
								Text("Choose a location:")
									.foregroundColor(.white)
									.font(.headline)
									.padding(.leading, 10)
								
								if isLoading {
									ProgressView()
										.tint(.white)
										.padding()
								} else if let error = errorMessage {
									Text("Error loading locations: \(error)")
										.foregroundColor(.red)
										.padding()
								} else {
									Picker("Select School", selection: $selectedSchool) {
										ForEach(weatherLocations, id: \.locationName) { location in
											Text(location.locationName)
										}
									}
									.pickerStyle(MenuPickerStyle())
									.padding(.horizontal, 20)
									
									if let location = weatherLocations.first(where: { $0.locationName == selectedSchool }),
									   let url = URL(string: location.locationWeatherLink) {
										WebView(url: url)
											.frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.78)
											.cornerRadius(16)
											.padding(.top, 16)
											.padding(.horizontal, geometry.size.width * 0.05)
									}
								}
							}
							.padding(.bottom, geometry.safeAreaInsets.bottom)
						}
					}
					.ignoresSafeArea(edges: .top)
				}
			}
			.toolbar(.hidden, for: .navigationBar)
			.onAppear {
				fetchWeatherLocations()
			}
		}

	}
	
	private func fetchWeatherLocations() {
		isLoading = true
		errorMessage = nil
		
		Task {
			do {
				print("Starting to fetch weather locations from Supabase")
				
				let locations: [WeatherLocation] = try await supabase
					.from("WeatherLinks")
					.select()
					.order("locationName")
					.execute()
					.value
				
				print("Successfully fetched \(locations.count) weather locations")
				
				await MainActor.run {
					self.weatherLocations = locations
					self.isLoading = false
					
					// Set default to Marlowe Middle School if available
					if !locations.isEmpty {
						if locations.contains(where: { $0.locationName == "Marlowe Middle School" }) {
							self.selectedSchool = "Marlowe Middle School"
						} else {
							// Otherwise use first available location
							self.selectedSchool = locations[0].locationName
						}
					}
				}
			} catch {
				print("Error fetching weather locations: \(error)")
				await MainActor.run {
					self.errorMessage = error.localizedDescription
					self.weatherLocations = []
					self.isLoading = false
				}
			}
		}
	}
}
