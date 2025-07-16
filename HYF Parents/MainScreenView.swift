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
	
	let columns = [
		GridItem(.fixed(100), spacing: 60),
		GridItem(.fixed(100), spacing: 60)
	]
	
	var body: some View {
		NavigationView {
			ZStack {
				Color.black.ignoresSafeArea()
				
				GeometryReader { geometry in
					ScrollView ( .vertical, showsIndicators: false) {
						VStack(spacing: 0) {
							// Top: Banner
							BannerView(geometry: geometry)
								.padding(.top, 70) // Ensure consistent top padding
							
							// Middle: Social links
							VStack(spacing: 6) {
								HStack(spacing: 20) {
									socialButton(image: "icon_Facebook", url: "https://www.facebook.com/Huntley-Red-Raiders-Youth-Football-League-112134028046472", label: "Facebook")
									socialButton(image: "icon_Instagram", url: "https://www.instagram.com/hyf_redraiders/", label: "Instagram")
									socialButton(image: "icon_X", url: "https://twitter.com/huntleyyouthrr", label: "X")
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
										mainButton(image: "icon_Calendar", label: "Important Dates", bg: Color.white.opacity(1.0), fg: .black, url: "https://www.huntleyyouthfootball.org/page/show/6967331-important-dates", openURL: openURL)
										Button(action: {
											selectedTab = 4
										}) {
											VStack(spacing: 8) {
												Image("icon_WeatherAlert")
													.resizable()
													.frame(width: 70, height: 70)
												Text("Weather\nAlerts")
													.font(.headline)
													.fontWeight(.semibold)
													.foregroundColor(.black)
													.multilineTextAlignment(.center)
													.lineLimit(nil)
													.minimumScaleFactor(0.7)
											}
											.frame(width: 120, height: 130)
											.background(Color.white.opacity(1.0))
											.cornerRadius(16)
											.shadow(color: Color.black.opacity(0.10), radius: 4, y: 2)
										}
										.buttonStyle(.plain)
										.accessibilityLabel("Weather Alerts")
										mainButton(image: "icon_Registration", label: "Registration", bg: Color.white.opacity(1.0), fg: .black, url: "https://www.huntleyyouthfootball.org/page/show/6967329-registration", openURL: openURL)
										mainButton(image: "icon_SpiritStore", label: "Spirit Stores", bg: Color.white.opacity(1.0), fg: .black, url: "https://www.huntleyyouthfootball.org/spiritstore", openURL: openURL)
										mainButton(image: "icon_TCYFL", label: "TCYFL", bg: Color.white.opacity(1.0), fg: .black, url: "https://www.tcyfl.net/index.php", openURL: openURL)
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
		}
		.navigationViewStyle(StackNavigationViewStyle()) // Ensure consistent navigation style
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
	
	// MARK: - Main Button View Builder
	private func mainButton(
		image: String,
		label: String,
		bg: Color,
		fg: Color,
		url: String,
		openURL: OpenURLAction
	) -> some View {
		Button(action: {
			if let url = URL(string: url) {
				if UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url)
				} else {
					openURL(url)
				}
			}
		}) {
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
		.buttonStyle(.plain)
		.accessibilityLabel(label)
	}
}
