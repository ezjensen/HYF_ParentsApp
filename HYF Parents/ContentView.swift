//
//  ContentView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 6/20/25.
//

import SwiftUI
import WebKit
import PDFKit

// MARK: Main ContentView with TabView
struct ContentView: View {
	@State private var selectedTab = 0
	
	var body: some View {
		NavigationView {
			TabView(selection: $selectedTab) {
				MainScreenView(selectedTab: $selectedTab)
					.tabItem {
						Image(systemName: "house.fill")
						Text("Home")
					}
					.tag(0)
				TackleView(selectedTab: $selectedTab)
					.tabItem {
						Image(systemName: "sportscourt")
						Text("Tackle")
					}
					.tag(1)
				SevenVSevenView(selectedTab: $selectedTab)
					.tabItem {
						Image(systemName: "person.3.fill")
						Text("7v7")
					}
					.tag(2)
				GirlsFlagView(selectedTab: $selectedTab)
					.tabItem {
						Image(systemName: "flag.fill")
						Text("Girls Flag")
					}
					.tag(3)
				WeatherAlertsView(selectedTab: $selectedTab)
					.tabItem {
						Image(systemName: "cloud.bolt.fill")
						Text("Weather")
					}
					.tag(4)
			}
			.accentColor(.red)
			.onAppear {
				let appearance = UITabBarAppearance()
				appearance.configureWithOpaqueBackground()
				appearance.backgroundColor = UIColor.systemGray6
				UITabBar.appearance().standardAppearance = appearance
				if #available(iOS 15.0, *) {
					UITabBar.appearance().scrollEdgeAppearance = appearance
				}
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
