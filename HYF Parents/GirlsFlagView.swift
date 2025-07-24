//
//  GirlsFlagView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/15/25.
//

import SwiftUI
import WebKit

struct GirlsFlagView: View {
	@Environment(\.openURL) var openURL
	@State private var showingWebView = false
	@State private var webViewTitle = ""
	@State private var webViewURL: URL? = nil
	@State private var showingCalendarActionSheet = false
	private let scheduleURLs = [
		"K-3": "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=flag&division=K3",
		"4-5th": "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=flag&division=4-5th",
		"6-8th": "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=flag&division=6-8th"
	]
	@Binding var selectedTab: Int
	
	// For preview purposes
	init(selectedTab: Binding<Int> = .constant(3)) {
		self._selectedTab = selectedTab
	}
	
	let columns = [
		GridItem(.fixed(100), spacing: 60),
		GridItem(.fixed(100), spacing: 60)
	]
	
	private let socialURLs = [
		"Facebook": "https://www.facebook.com/groups/tcyflgirlsflag",
		"Instagram": "https://www.instagram.com/huntleyredraidersgirlsflag",
		"X": "https://twitter.com/huntleygirlsflag"
	]
	
	var body: some View {
		NavigationView {
			ZStack {
				Color.black.ignoresSafeArea()
				
				GeometryReader { geometry in
					ScrollView (.vertical, showsIndicators: false) {
						VStack(spacing: 0) {
							// Use updated BannerView with tab binding
							BannerView(geometry: geometry, selectedTab: $selectedTab)
								.padding(.top, 70)
							
							// Social links
							VStack(spacing: 6) {
								HStack(spacing: 20) {
									socialButton(image: "icon_Facebook", url: socialURLs["Facebook"] ?? "", label: "Facebook")
									socialButton(image: "icon_Instagram", url: socialURLs["Instagram"] ?? "", label: "Instagram")
									socialButton(image: "icon_X", url: socialURLs["X"] ?? "", label: "X")
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
										// League Calendar - Now opens in-app
										Button(action: {
											showingCalendarActionSheet = true
										}) {
											mainButtonView(image: "icon_Calendar", label: "League Calendar", bg: Color.white.opacity(1.0), fg: .black)
										}
										.confirmationDialog("Select Division", isPresented: $showingCalendarActionSheet) {
											Button("K-3") {
												webViewTitle = "K-3 Schedule"
												webViewURL = URL(string: scheduleURLs["K-3"] ?? "")
												showingWebView = true
											}
											Button("4-5th") {
												webViewTitle = "4-5th Schedule"
												webViewURL = URL(string: scheduleURLs["4-5th"] ?? "")
												showingWebView = true
											}
											Button("6-8th") {
												webViewTitle = "6-8th Schedule"
												webViewURL = URL(string: scheduleURLs["6-8th"] ?? "")
												showingWebView = true
											}
										}
										
										// League Rules Button
										NavigationLink {
											PDFPreviewView(url: URL(string: "https://www.tcyfl.net/grabit.php?file=TCYFL_Girls_Fall_Flag_Rules_2024.pdf")!)
										} label: {
											VStack(spacing: 8) {
												Image("icon_Rules")
													.resizable()
													.frame(width: 70, height: 70)
												Text("League Rules")
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
										// First invisible placeholder button
										Button(action: {}) {
											VStack(spacing: 8) {
												Color.clear
													.frame(width: 70, height: 70)
												Text("")
													.font(.headline)
											}
											.frame(width: 120, height: 130)
										}
										.buttonStyle(.plain)
										.opacity(0)
										
										// Second invisible placeholder button
										Button(action: {}) {
											VStack(spacing: 8) {
												Color.clear
													.frame(width: 70, height: 70)
												Text("")
													.font(.headline)
											}
											.frame(width: 120, height: 130)
										}
										.buttonStyle(.plain)
										.opacity(0)
									}
								}
								.padding(.vertical, 30)
								.padding(.horizontal, 20)
								.padding(.top, 20)
								.padding(.bottom, geometry.safeAreaInsets.bottom)
								
								
								
								
								Spacer(minLength: 20) // Ensure some space at bottom
							}
						}
					}
					.ignoresSafeArea(edges: .top)
				}
			}
			.navigationBarHidden(true)
			.sheet(isPresented: $showingWebView) {
				if let url = webViewURL {
					webViewSheet(title: webViewTitle, url: url)
				}
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
	
	// MARK: - Helper to create WebView sheet
	private func webViewSheet(title: String, url: URL) -> some View {
		NavigationView {
			if title.contains("Schedule") {
				EnhancedWebView(url: url, divToShow: "box5")
					.navigationBarTitle(title, displayMode: .inline)
					.navigationBarItems(trailing: Button("Done") {
						showingWebView = false
					})
					.preferredColorScheme(.dark) // Force dark mode
			} else {
				StandardWebView(url: url)
					.navigationBarTitle(title, displayMode: .inline)
					.navigationBarItems(trailing: Button("Done") {
						showingWebView = false
					})
			}
		}
		.accentColor(.red) // Use team color for navigation elements
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
	
	// Add social button builder
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
