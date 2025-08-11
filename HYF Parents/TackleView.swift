//
//  TackleView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/15/25.
//

import SwiftUI
import WebKit

struct TackleView: View {
	@Environment(\.openURL) var openURL
	@State private var showingWebView = false
	@State private var webViewTitle = ""
	@State private var webViewURL: URL? = nil
	@State private var showingCalendarActionSheet = false
	@Binding var selectedTab: Int
	
	// For preview purposes
	init(selectedTab: Binding<Int> = .constant(1)) {
		self._selectedTab = selectedTab
	}
	
	let columns = [
		GridItem(.fixed(100), spacing: 60),
		GridItem(.fixed(100), spacing: 60)
	]
	
	// Add social media URLs specific to Tackle
	private let socialURLs = [
		"Facebook": "https://www.facebook.com/groups/tcyfltackle",
		"Instagram": "https://www.instagram.com/huntleyredraiderstackle",
		"X": "https://twitter.com/huntleytackle"
	]
	
	var body: some View {
		NavigationView {
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
							
							/// Main grid of buttons
							VStack {
								VStack {
									LazyVGrid(columns: columns, spacing: 25) {
										// League Calendar - Now opens selection dialog
										Button(action: {
											showingCalendarActionSheet = true
										}) {
											mainButtonView(image: "icon_Calendar", label: "League Calendar", bg: Color.white.opacity(1.0), fg: .black)
										}
										.confirmationDialog("Select Division", isPresented: $showingCalendarActionSheet) {
											// Varsity Divisions
											Button("Vasity - BIG 10") {
												webViewTitle = "Varsity Schedule"
												webViewURL = URL(string: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=varsity")
												showingWebView = true
											}
											// JV Divisions
											Button("JV - BIG 10") {
												webViewTitle = "JV Schedule"
												webViewURL = URL(string: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=jv")
												showingWebView = true
											}
											// Lightweight Divisions
											Button("Lightweight - BIG 10") {
												webViewTitle = "Lightweight Schedule"
												webViewURL = URL(string: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=lightweight")
												showingWebView = true
											}
											// Middleweight Divisions
											Button("Middleweight - BIG 10") {
												webViewTitle = "Middleweight Schedule"
												webViewURL = URL(string: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=middleweight")
												showingWebView = true
											}
											Button("Middleweight - PAC") {
												webViewTitle = "Middleweight Schedule"
												webViewURL = URL(string: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=middleweight")
												showingWebView = true
											}
											// Featherweight Divisions
											Button("Featherweight - BIG 10") {
												webViewTitle = "Feather Schedule"
												webViewURL = URL(string: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=feather")
												showingWebView = true
											}
											Button("Featherweight - PAC") {
												webViewTitle = "Featherweight Schedule"
												webViewURL = URL(string: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=featherweight")
												showingWebView = true
											}
											// Bantam Divisions
											Button("Bantam - BIG 10") {
												webViewTitle = "Bantam Schedule"
												webViewURL = URL(string: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=bantam")
												showingWebView = true
											}
											Button("Bantam - PAC") {
												webViewTitle = "Bantam Schedule"
												webViewURL = URL(string: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=bantam")
												showingWebView = true
											}
											// Flyweight Divisions
											Button("Flyweight - PAC") {
												webViewTitle = "Flyweight Schedule"
												webViewURL = URL(string: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=flyweight")
												showingWebView = true
											}
										}
										
										// Field Maps
										/* Moved this to the MainScreenView.swift file
										Button(action: {
											webViewTitle = "Field Maps"
											webViewURL = URL(string: "https://www.tcyfl.net/index.php?option=com_content&view=article&id=7&Itemid=17")
											showingWebView = true
										}) {
											mainButtonView(image: "icon_Maps", label: "Field Maps", bg: Color.white.opacity(1.0), fg: .black)
										}
										*/
										
										// League Rules
										NavigationLink {
											PDFPreviewView(url: URL(string: "https://www.tcyfl.net/grabit.php?file=TCYFL_Football_Playing_Rules_FINAL.pdf")!, title: "Tackle League Rules")
										} label: {
											VStack(spacing: 8) {
												Image("icon_Rules")
													.resizable()
													.frame(width: 70, height: 70)
												Text("Tackle League Rules")
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
										
										/* Commented out as this is not ready. HYF doesn't know what direction they want to go yet
										// VEO Camera - Will open in-app when URL is provided
										Button(action: {
											webViewTitle = "VEO Camera"
											webViewURL = URL(string: "https://veo.co/")
											showingWebView = true
										}) {
											mainButtonView(image: "icon_VideoCamera", label: "VEO Camera", bg: Color.white.opacity(1.0), fg: .black)
										}
										*/
										// Invisible placeholder button
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
			.navigationBarHidden(true)
			.sheet(isPresented: $showingWebView) {
				if let url = webViewURL {
					webViewSheet(title: webViewTitle, url: url)
				}
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
	
	// MARK: - Helper to create WebView sheet in TackleView.swift
	private func webViewSheet(title: String, url: URL) -> some View {
		NavigationView {
			if title.contains("Schedule") {
				EnhancedWebView(url: url, divToShow: "box5")
					.navigationBarTitle(title, displayMode: .inline)
					.navigationBarItems(trailing: Button("Done") {
						showingWebView = false
					})
					.preferredColorScheme(.dark)
			} else {
				StandardWebView(url: url)
					.navigationBarTitle(title, displayMode: .inline)
					.navigationBarItems(trailing: Button("Done") {
						showingWebView = false
					})
			}
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
