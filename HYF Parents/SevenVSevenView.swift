//
//  SevenVSevenView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/15/25.
//

import SwiftUI
import WebKit

struct SevenVSevenView: View {
	@Environment(\.openURL) var openURL
	
	@State private var showingRulesActionSheet = false
	@State private var selectedRulesURL: URL? = nil
	@State private var showingPDFView = false
	@State private var showingWebView = false
	@State private var webViewTitle = ""
	@State private var webViewURL: URL? = nil
	@State private var showingCalendarActionSheet = false
	@State private var rulesTitle: String = "League Rules"
	@Binding var selectedTab: Int
	
	// Use the shared stores
	@EnvironmentObject private var rulesStore: LeagueRulesStore
	@EnvironmentObject private var scheduleStore: ScheduleStore
	
	// For preview purposes
	init(selectedTab: Binding<Int> = .constant(2)) {
		self._selectedTab = selectedTab
	}
	
	let columns = [
		GridItem(.fixed(100), spacing: 60),
		GridItem(.fixed(100), spacing: 60)
	]
	
	private let socialURLs = [
		"Facebook": "https://www.facebook.com/groups/tcyfl7v7",
		"Instagram": "https://www.instagram.com/huntleyredraiders7v7",
		"X": "https://twitter.com/huntley7v7"
	]
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color.black.ignoresSafeArea()
				
				GeometryReader { geometry in
					ScrollView(.vertical, showsIndicators: false) {
						VStack(spacing: 0) {
							// Updated to use the tab-aware BannerView
							BannerView(geometry: geometry, selectedTab: $selectedTab)
								.padding(.top, 70)
							
							// Social links
							VStack(spacing: 6) {
								HStack(spacing: 20) {
									socialButton(image: "icon_Facebook", url: "https://www.facebook.com/Huntley-Red-Raiders-Youth-Football-League-112134028046472", label: "Facebook")
									socialButton(image: "icon_Instagram", url: "https://www.instagram.com/hyf_redraiders/", label: "Instagram")
									socialButton(image: "icon_X", url: "https://twitter.com/huntleyyouthrr", label: "X")
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
										// League Calendar - Now opens selection dialog
										Button(action: {
											showingCalendarActionSheet = true
										}) {
											mainButtonView(image: "icon_Calendar", label: "7v7 \nSchedules", bg: Color.white.opacity(1.0), fg: .black)
										}
										.confirmationDialog("Select Division", isPresented: $showingCalendarActionSheet) {
											Button("K-1st") {
												webViewTitle = "K-1st Schedule"
												webViewURL = URL(string: scheduleStore.sevenOnSevenK1Link)
												showingWebView = true
											}
											Button("2-3rd") {
												webViewTitle = "2-3rd Schedule"
												webViewURL = URL(string: scheduleStore.sevenOnSeven2To3Link)
												showingWebView = true
											}
											Button("4-5th") {
												webViewTitle = "4-5th Schedule"
												webViewURL = URL(string: scheduleStore.sevenOnSeven4To5Link)
												showingWebView = true
											}
											Button("6-7th") {
												webViewTitle = "6-7th Schedule"
												webViewURL = URL(string: scheduleStore.sevenOnSeven6To7Link)
												showingWebView = true
											}
											Button("8th") {
												webViewTitle = "8th Schedule"
												webViewURL = URL(string: scheduleStore.sevenOnSeven8Link)
												showingWebView = true
											}
										}
										
										// League Rules Button with Action Sheet - Using shared store
										if rulesStore.isLoading {
											ProgressView()
												.tint(.white)
												.frame(width: 120, height: 130)
												.background(Color.white.opacity(1.0))
												.cornerRadius(16)
										} else if rulesStore.loadError {
											Button(action: {
												rulesStore.fetchAllRules()
											}) {
												VStack(spacing: 8) {
													Image("icon_Rules")
														.resizable()
														.frame(width: 70, height: 70)
													Text("Retry Loading")
														.font(.headline)
														.fontWeight(.semibold)
														.foregroundColor(.black)
												}
												.frame(width: 120, height: 130)
												.background(Color.white.opacity(1.0))
												.cornerRadius(16)
												.shadow(color: Color.black.opacity(0.10), radius: 4, y: 2)
											}
										} else {
											Button(action: {
												showingRulesActionSheet = true
											}) {
												VStack(spacing: 8) {
													Image("icon_Rules")
														.resizable()
														.frame(width: 70, height: 70)
													Text("7v7 \nRules")
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
											.confirmationDialog("Select Rules", isPresented: $showingRulesActionSheet) {
												Button("K-3 Rules") {
													if let url = URL(string: rulesStore.sevenOnSevenK3RulesLink) {
														selectedRulesURL = url
														rulesTitle = "7v7 K-3 Rules"
														showingPDFView = true
													}
												}
												Button("4-8 Rules") {
													if let url = URL(string: rulesStore.sevenOnSevenUpperRulesLink) {
														selectedRulesURL = url
														rulesTitle = "7v7 4-8 Rules"
														showingPDFView = true
													}
												}
											}
										}
										
										// First invisible placeholder
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
										
										// Second invisible placeholder
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
								
								Spacer()
							}
						}
					}
					.ignoresSafeArea(edges: .top)
				}
			}
			.sheet(isPresented: $showingPDFView) {
				if let url = selectedRulesURL {
					NavigationStack {
						PDFPreviewView(url: url, title: rulesTitle)
					}
					.tint(.red)
				}
			}
			.sheet(isPresented: $showingWebView) {
				if let url = webViewURL {
					webViewSheet(title: webViewTitle, url: url)
				}
			}
			.toolbar(.hidden, for: .navigationBar)
		}

	}
	
	// MARK: - Helper to create WebView sheet
	private func webViewSheet(title: String, url: URL) -> some View {
		NavigationStack {
			if title.contains("Schedule") {
				EnhancedWebView(url: url, divToShow: "box5")
					.navigationTitle(title)
					.navigationBarTitleDisplayMode(.inline)
					.toolbar {
						ToolbarItem(placement: .topBarLeading) {
							shareButton(url: url)
						}
						ToolbarItem(placement: .topBarTrailing) {
							Button("Done") {
								showingWebView = false
							}
						}
					}
					.preferredColorScheme(.dark)
			} else {
				StandardWebView(url: url)
					.navigationTitle(title)
					.navigationBarTitleDisplayMode(.inline)
					.toolbar {
						ToolbarItem(placement: .topBarTrailing) {
							Button("Done") {
								showingWebView = false
							}
						}
					}
			}
		}
		.tint(.red)
	}
	
	private func shareButton(url: URL) -> some View {
		Button(action: {
			let shareText = "Check out the \(webViewTitle):"
			let shareItems: [Any] = [shareText, url]
			
			let activityVC = UIActivityViewController(
				activityItems: shareItems,
				applicationActivities: nil
			)
			
			if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			   let rootViewController = windowScene.windows.first?.rootViewController {
				// Use the right controller (account for possible presented controllers)
				var currentVC = rootViewController
				while let presentedVC = currentVC.presentedViewController {
					currentVC = presentedVC
				}
				currentVC.present(activityVC, animated: true)
			}
		}) {
			Image(systemName: "square.and.arrow.up")
		}
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
				.fixedSize(horizontal: false, vertical: true) // Allow vertical expansion
				.lineLimit(2) // Limit to 2 lines
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
