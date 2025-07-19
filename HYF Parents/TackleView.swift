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
	@State private var showingBIG10ActionSheet = false
	@State private var showingPACActionSheet = false
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
										.confirmationDialog("Select Conference", isPresented: $showingCalendarActionSheet) {
											Button("BIG 10 Schedules") {
												showingBIG10ActionSheet = true
											}
											Button("PAC Schedules") {
												showingPACActionSheet = true
											}
										}
										
										// Field Maps
										Button(action: {
											webViewTitle = "Field Maps"
											webViewURL = URL(string: "https://www.tcyfl.net/index.php?option=com_content&view=article&id=7&Itemid=17")
											showingWebView = true
										}) {
											mainButtonView(image: "icon_Maps", label: "Field Maps", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										// League Rules
										NavigationLink {
											PDFPreviewView(url: URL(string: "https://www.tcyfl.net/grabit.php?file=TCYFL_Football_Playing_Rules_FINAL.pdf")!)
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
										
										// VEO Camera - Will open in-app when URL is provided
										Button(action: {
											webViewTitle = "VEO Camera"
											webViewURL = URL(string: "https://veo.co/")
											showingWebView = true
										}) {
											mainButtonView(image: "icon_VideoCamera", label: "VEO Camera", bg: Color.white.opacity(1.0), fg: .black)
										}
										
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
		.sheet(isPresented: $showingBIG10ActionSheet) {
			ZStack {
				// Background blur
				Color.black.opacity(0.9)
					.edgesIgnoringSafeArea(.all)
				
				VStack(spacing: 20) {
					Text("BIG 10 Divisions")
						.font(.title)
						.fontWeight(.bold)
						.foregroundColor(.white)
						.padding(.top, 20)
					
					ScrollView {
						VStack(spacing: 15) {
							divisionButton(title: "Varsity", url: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=varsity")
							divisionButton(title: "JV", url: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=jv")
							divisionButton(title: "Lightweight", url: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=lightweight")
							divisionButton(title: "Middleweight", url: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=middleweight")
							divisionButton(title: "Feather", url: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=feather")
							divisionButton(title: "Bantam", url: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=bantam")
						}
						.padding()
					}
					
					Button("Close") {
						showingBIG10ActionSheet = false
					}
					.font(.headline)
					.foregroundColor(.white)
					.padding(.vertical, 15)
					.padding(.horizontal, 40)
					.background(Color.red)
					.cornerRadius(10)
					.padding(.bottom, 20)
				}
				.padding()
			}
		}
		.sheet(isPresented: $showingPACActionSheet) {
			ZStack {
				// Background blur
				Color.black.opacity(0.9)
					.edgesIgnoringSafeArea(.all)
				
				VStack(spacing: 20) {
					Text("PAC Divisions")
						.font(.title)
						.fontWeight(.bold)
						.foregroundColor(.white)
						.padding(.top, 20)
					
					ScrollView {
						VStack(spacing: 15) {
							divisionButton(title: "Middleweight", url: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=middleweight")
							divisionButton(title: "Featherweight", url: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=featherweight")
							divisionButton(title: "Bantam", url: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=bantam")
							divisionButton(title: "Flyweight", url: "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=flyweight")
						}
						.padding()
					}
					
					Button("Close") {
						showingPACActionSheet = false
					}
					.font(.headline)
					.foregroundColor(.white)
					.padding(.vertical, 15)
					.padding(.horizontal, 40)
					.background(Color.red)
					.cornerRadius(10)
					.padding(.bottom, 20)
				}
				.padding()
			}
		}
	}
	
	// MARK: - Division Button with Glass Effect
	private func divisionButton(title: String, url: String) -> some View {
		Button {
			webViewTitle = "\(title) Schedule"
			webViewURL = URL(string: url)
			showingWebView = true
			showingBIG10ActionSheet = false
			showingPACActionSheet = false
		} label: {
			HStack {
				Text(title)
					.font(.headline)
					.fontWeight(.semibold)
					.foregroundColor(.white)
				
				Spacer()
				
				Image(systemName: "chevron.right")
					.foregroundColor(.white)
			}
			.padding()
			.frame(maxWidth: .infinity)
			.background(
				RoundedRectangle(cornerRadius: 16)
					.fill(Color.white.opacity(0.15))
					.background(
						RoundedRectangle(cornerRadius: 16)
							.fill(.ultraThinMaterial)
							.blur(radius: 0.5)
					)
			)
			.overlay(
				RoundedRectangle(cornerRadius: 16)
					.stroke(LinearGradient(
						gradient: Gradient(colors: [.white.opacity(0.6), .clear, .white.opacity(0.3)]),
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					), lineWidth: 1.5)
			)
			.shadow(color: Color.white.opacity(0.1), radius: 8, x: 0, y: 4)
		}
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
