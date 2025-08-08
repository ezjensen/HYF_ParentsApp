//
//  MainScreenView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/15/25.
//

import SwiftUI

// MARK: - Main Screen with Background, Logo, and Overlay
struct MainScreenView: View {
	@Environment(\.openURL) var openURL
	@Binding var selectedTab: Int
	@State private var showImportantDates = false
	@State private var showRegistration = false
	@State private var showSpiritStore = false
	@State private var showTCYFL = false
	@State private var showFieldMaps = false
	@State private var showCoachesCorner = false
	@State private var showingWebView = false
	@State private var webViewTitle = ""
	@State private var webViewURL: URL? = nil
	
	let columns = [
		GridItem(.fixed(100), spacing: 60),
		GridItem(.fixed(100), spacing: 60)
	]
	
	var body: some View {
		NavigationView {
			ZStack {
				Color.black.ignoresSafeArea()
				
				GeometryReader { geometry in
					ScrollView(.vertical, showsIndicators: false) {
						VStack(spacing: 0) {
							// Top: Banner
							BannerView(geometry: geometry, selectedTab: $selectedTab)
								.padding(.top, 70) // Ensure consistent top padding
							
							// Middle: Social links
							VStack(spacing: 6) {
								HStack(spacing: 20) {
									socialButton(image: "icon_Facebook", url: "https://www.facebook.com/Huntley-Red-Raiders-Youth-Football-League-112134028046472", label: "Facebook")
									socialButton(image: "icon_Instagram", url: "https://www.instagram.com/hyf_redraiders/", label: "Instagram")
									socialButton(image: "icon_X", url: "https://twitter.com/huntleyyouthrr", label: "X")
									//socialButton(image: "icon_YouTube", url: "https://www.huntleyyouthfootball.org/home", label: "Youtube")
									socialButton(image: "icon_Website", url: "https://www.huntleyyouthfootball.org/home", label: "HYF Red Raiders")
								}
							
								.padding(.vertical, 4)
								.padding(.horizontal, 8)
								.background(.ultraThinMaterial.opacity(0.7))
								.background(Color.white.opacity(0.5))
								.cornerRadius(12)
								.shadow(color: Color.black, radius: 8, y: 4)
								.padding(.horizontal, 40)
								.padding(.top, 10)
							}
							
							// Main grid of buttons
							VStack {
								VStack {
									LazyVGrid(columns: columns, spacing: 25) {
										// Important Dates button
										Button(action: {
											showImportantDates = true
										}) {
											mainButtonView(image: "icon_Calendar", label: "Important Dates", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										// Field Maps button - Modified to display Box 5 within the app
										Button(action: {
											showFieldMaps = true
										}) {
											mainButtonView(image: "icon_Maps", label: "Field\nLocations", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										/*
										 // Weather Alerts button
										 Button(action: {
										 selectedTab = 4
										 }) {
										 mainButtonView(image: "icon_WeatherAlert", label: "Weather\nAlerts", bg: Color.white.opacity(1.0), fg: .black)
										 }
										 .buttonStyle(.plain)
										 .accessibilityLabel("Weather Alerts")
										 */
										
										// Registration button
										Button(action: {
											showRegistration = true
										}) {
											mainButtonView(image: "icon_Registration", label: "Registration", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										// Spirit Store button
										Button(action: {
											showSpiritStore = true
										}) {
											mainButtonView(image: "icon_SpiritStore", label: "Spirit Stores", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										// TCYFL button
										Button(action: {
											showTCYFL = true
										}) {
											mainButtonView(image: "icon_TCYFL", label: "TCYFL", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										// Coaches Resources button
										Button(action: {
											showCoachesCorner = true
										}) {
											mainButtonView(image: "icon_Coach", label: "Coach Resources", bg: Color.white.opacity(1.0), fg: .black)
										}
									}
								}
								.padding(.vertical, 30)
								.padding(.horizontal, 20)
								.padding(.top, 20)
								.padding(.bottom, geometry.safeAreaInsets.bottom)
								
								Spacer()
							}
						}
					}
					.ignoresSafeArea(edges: .top) // This helps remove the top space
				}
			}
			.navigationBarHidden(true)
			.sheet(isPresented: $showImportantDates) {
				webViewSheet(title: "Important Dates", url: URL(string: "https://www.huntleyyouthfootball.org/page/show/6967331-important-dates")!)
			}
			// In your MainScreenView.swift file, modify the .sheet for showFieldMaps:
			
			.sheet(isPresented: $showFieldMaps) {
				NavigationStack {
					FieldLocationsView()
						.navigationTitle("Field Locations")
						.navigationBarTitleDisplayMode(.inline)
						.toolbar {
							ToolbarItem(placement: .topBarTrailing) {
								Button("Done") {
									showFieldMaps = false
								}
							}
						}
				}
				.accentColor(.red)
			}
			 
			.sheet(isPresented: $showRegistration) {
				webViewSheet(title: "Registration", url: URL(string: "https://www.huntleyyouthfootball.org/page/show/6967329-registration")!)
			}
			.sheet(isPresented: $showSpiritStore) {
				webViewSheet(title: "Spirit Store", url: URL(string: "https://www.huntleyyouthfootball.org/spiritstore")!)
			}
			.sheet(isPresented: $showTCYFL) {
				webViewSheet(title: "TCYFL", url: URL(string: "https://www.tcyfl.net/index.php")!)
			}
			.sheet(isPresented: $showCoachesCorner) {
				CoachResourcesView()
			}
			// Add this sheet for webViewURL
			.sheet(isPresented: $showingWebView) {
				if webViewTitle == "Field Locations" {
					// Use a standard NavigationStack instead of NavigationView
					NavigationStack {
						FieldLocationsView()
							.navigationTitle("Field Locations")
							.navigationBarTitleDisplayMode(.inline)
							.toolbar {
								ToolbarItem(placement: .topBarTrailing) {
									Button("Done") {
										showingWebView = false
									}
								}
							}
					}
					.accentColor(.red)
				} else if let url = webViewURL {
					webViewSheet(title: webViewTitle, url: url)
				}
			}
		}
		.navigationViewStyle(StackNavigationViewStyle()) // Ensure consistent navigation style
	}
	
	// MARK: - Helper to create WebView sheet
	private func webViewSheet(title: String, url: URL) -> some View {
		NavigationView {
			WebView(url: url)
				.navigationBarTitle(title, displayMode: .inline)
				.navigationBarItems(trailing: Button("Done") {
					// Close the appropriate sheet based on title
					switch title {
						case "Important Dates":
							showImportantDates = false
						case "Registration":
							showRegistration = false
						case "Spirit Store":
							showSpiritStore = false
						case "TCYFL":
							showTCYFL = false
						case "Coaches Corner":
							showCoachesCorner = false
						default:
							showingWebView = false
					}
				})
		}
		.accentColor(.red)
	}
	
	// MARK: - Button view component
	private func mainButtonView(image: String, label: String, bg: Color, fg: Color) -> some View {
		VStack(spacing: 8) {
			Image(image)
				.resizable()
				.frame(width: 70, height: 70)
			Text(label)
				.font(.headline)
				.fontWeight(.semibold)
				.foregroundColor(fg)
				.multilineTextAlignment(.center)
				.lineLimit(nil)
				.minimumScaleFactor(0.7)
		}
		.frame(width: 120, height: 130)
		.background(bg)
		.cornerRadius(16)
		.shadow(color: Color.black.opacity(0.10), radius: 4, y: 2)
	}
	
	// MARK: - Social media button builder
	@ViewBuilder
	private func socialButton(image: String, url: String, label: String) -> some View {
		Button(action: {
			if let url = URL(string: url) {
				openURL(url)
			}
		}) {
			Image(image)
				.resizable()
				.frame(width: 32, height: 32)
				.accessibilityLabel(label)
		}
		.buttonStyle(.plain)
	}
}
