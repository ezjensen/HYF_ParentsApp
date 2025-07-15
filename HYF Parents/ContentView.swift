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
				TackleView()
					.tabItem {
						Image(systemName: "sportscourt")
						Text("Tackle")
					}
					.tag(1)
				SevenVSevenView()
					.tabItem {
						Image(systemName: "person.3.fill")
						Text("7v7")
					}
					.tag(2)
				GirlsFlagView()
					.tabItem {
						Image(systemName: "flag.fill")
						Text("Girls Flag")
					}
					.tag(3)
				WeatherAlertsView()
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
	
	var body: some View {
		ZStack {
			Image("HYF_RedRaiders_Banner")
				.resizable()
				.frame(height: geometry.size.height * 0.12)
				.clipped()
				.opacity(0.9)
				.padding(.top, geometry.safeAreaInsets.top)
				.frame(maxWidth: .infinity)
		}
		.frame(height: geometry.size.height * 0.12 + geometry.safeAreaInsets.top)
	}
}
