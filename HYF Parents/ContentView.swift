//
//  ContentView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 6/20/25.
//

import SwiftUI

// MARK: Main ContentView with TabView
struct ContentView: View {
	@State private var selectedTab = 0
	@State private var previousTab = 0
	@State private var showingAbout = false
	
	private var aboutMessage: String {
		let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
		let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
		return "This app was made for Huntley Youth Football and for the Player Parents to put all resources in their hands.\n\nVersion: \(appVersion) (\(buildNumber))"
	}
	
	var body: some View {
		TabView(selection: $selectedTab) {
			Tab("Home", systemImage: "house.fill", value: 0) {
				MainScreenView(selectedTab: $selectedTab)
			}
			Tab("Tackle", systemImage: "sportscourt", value: 1) {
				TackleView(selectedTab: $selectedTab)
			}
			Tab("7v7", systemImage: "person.3.fill", value: 2) {
				SevenVSevenView(selectedTab: $selectedTab)
			}
			Tab("Girls Flag", systemImage: "flag.fill", value: 3) {
				GirlsFlagView(selectedTab: $selectedTab)
			}
			Tab("Weather", systemImage: "cloud.bolt.fill", value: 4) {
				WeatherAlertsView(selectedTab: $selectedTab)
			}
			Tab("About", systemImage: "ellipsis.circle", value: 5) {
				Color.black.ignoresSafeArea()
					.onAppear {
						showingAbout = true
					}
					.alert("About HYF Parents", isPresented: $showingAbout) {
						Button("OK", role: .cancel) {
							selectedTab = previousTab
						}
					} message: {
						Text(aboutMessage)
					}
			}
		}
		.tint(.red)
		.onChange(of: selectedTab) { oldValue, newValue in
			if newValue != 5 {
				previousTab = newValue
			}
		}
	}
}


// MARK: - Banner View Component
struct BannerView: View {
	var geometry: GeometryProxy
	@Binding var selectedTab: Int
	
	var body: some View {
		ZStack {
			// Choose banner image based on selected tab
			Image(bannerImageForTab(selectedTab))
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: geometry.size.width)
				.opacity(0.9)
		}
	}
	
	// Helper function to determine which banner to display
	private func bannerImageForTab(_ tab: Int) -> String {
		switch tab {
			case 3: // Girls Flag tab
				return "HYF_RedRaiders_Banner_GIRLS"
			default:
				return "HYF_RedRaiders_Banner"
		}
	}
}
