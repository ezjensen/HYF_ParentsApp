//
//  CoachResourcesView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/18/25.
//

import SwiftUI
import WebKit
import PDFKit

struct CoachResource: Identifiable, Codable {
	var id: Int
	var title: String
	var url: String
	var activeResource: Bool
	var resourceType: String?
	
	enum CodingKeys: String, CodingKey {
		case id
		case title = "resourceName"
		case url = "resourceLink"
		case activeResource = "ActiveResource"
		case resourceType = "resource_type"
	}
}

struct CoachResourcesView: View {
	@Environment(\.openURL) var openURL
	@Environment(\.dismiss) var dismiss
	@State private var showingWebView = false
	@State private var showingPDFView = false
	@State private var selectedPDFURL: URL?
	@State private var selectedPDFTitle: String = ""
	@State private var webViewTitle = ""
	@State private var webViewURL: URL? = nil
	@State private var showingAppStoreAlert = false
	@State private var showingSafetyResourcesList = false
	@State private var appToInstall = ""
	@State private var appStoreURL: URL?
	@State private var safetyResources: [CoachResource] = []
	@State private var isLoading = true
	@State private var errorMessage: String? = nil
	
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
							// Top Banner
							Image("HYF_RedRaiders_Banner")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: geometry.size.width)
								.opacity(0.9)
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
							
							// Main grid of buttons
							VStack {
								VStack {
									LazyVGrid(columns: columns, spacing: 25) {
										// TCYFL Passport button - Updated to open in default browser
										Button(action: {
											if let url = URL(string: "https://tcyfl.athleticpassports.com/login") {
												UIApplication.shared.open(url, options: [:], completionHandler: nil)
											}
										}) {
											mainButtonView(image: "icon_TCYFL", label: "TCYFL Passport", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										// Safety Resources button - Now shows a list
										Button(action: {
											showingSafetyResourcesList = true
										}) {
											mainButtonView(image: "icon_HYF_Safety", label: "Safety Resources", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										// Glazier Drive button - Updated to use simpler approach
										Button(action: {
											launchAppOrStore(
												appName: "Glazier Drive",
												appURLString: "hudl-glazier://", // Try this primary scheme
												appStoreId: "id1530106966"
											)
										}) {
											mainButtonView(image: "icon_GlazierDrive", label: "Glazier Drive", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										// Playmaker X button - Updated to use simpler approach
										Button(action: {
											launchAppOrStore(
												appName: "Playmaker X",
												appURLString: "playmakerx://", // Try this primary scheme
												appStoreId: "id1466963180"
											)
										}) {
											mainButtonView(image: "icon_PlaymakerX", label: "Playmaker X", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										// PCA Football button - Updated to use simpler approach
										Button(action: {
											if let url = URL(string: "https://pca.myabsorb.com/#/login") {
												UIApplication.shared.open(url, options: [:], completionHandler: nil)
											}
										}) {
											mainButtonView(image: "icon_PCA_Football", label: "Positive Coaching Alliance", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										// USA Football button - Updated to use simpler approach
										Button(action: {
											if let url = URL(string: "https://footballdevelopment.com/courses-certifications/") {
												UIApplication.shared.open(url, options: [:], completionHandler: nil)
											}
										}) {
											mainButtonView(image: "icon_USA_Football", label: "USA Football", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										// Invisible placeholders for grid layout consistency
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
			.navigationBarTitle("Coach Resources", displayMode: .inline)
			.navigationBarItems(trailing: Button("Done") {
				dismiss()
			})
			.sheet(isPresented: $showingWebView) {
				if let url = webViewURL {
					webViewSheet(title: webViewTitle, url: url)
				}
			}
			.sheet(isPresented: $showingPDFView) {
				if let url = selectedPDFURL {
					pdfViewSheet(title: selectedPDFTitle, url: url)
				}
			}
			.sheet(isPresented: $showingSafetyResourcesList) {
				safetyResourcesListView()
			}
			.alert(isPresented: $showingAppStoreAlert) {
				Alert(
					title: Text("Install \(appToInstall)"),
					message: Text("\(appToInstall) is not installed. Would you like to download it from the App Store?"),
					primaryButton: .default(Text("Download")) {
						if let url = appStoreURL {
							openURL(url)
						}
					},
					secondaryButton: .cancel()
				)
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.accentColor(.red)
		.onAppear {
			fetchSafetyResources()
		}
	}
	
	// MARK: - Fetch Safety Resources from Supabase
	private func fetchSafetyResources() {
		isLoading = true
		errorMessage = nil
		
		Task {
			do {
				// Query with debug logs
				print("Starting Supabase query to CoachResources table")
				
				let resources: [CoachResource] = try await supabase
					.from("CoachResources")
					.select()
					.order("resourceName")  // Sort alphabetically by resourceName
					.execute()
					.value
				
				print("Fetched \(resources.count) resources successfully")
				
				await MainActor.run {
					self.safetyResources = resources
					self.isLoading = false
				}
			} catch {
				print("Error fetching resources: \(error)")
				await MainActor.run {
					self.errorMessage = error.localizedDescription
					self.safetyResources = []
					self.isLoading = false
				}
			}
		}
	}
	
	// MARK: - Safety Resources List View
	private func safetyResourcesListView() -> some View {
		NavigationView {
			ZStack {
				if isLoading {
					ProgressView("Loading resources...")
				} else {
					List {
						if let error = errorMessage {
							Text("Error: \(error)")
								.foregroundColor(.red)
								.padding()
						} else if safetyResources.isEmpty {
							Text("No safety resources available")
								.foregroundColor(.gray)
								.padding()
						} else {
							ForEach(safetyResources) { resource in
								NavigationLink(destination: {
									if resource.url.hasSuffix(".pdf") {
										if let url = URL(string: resource.url) {
											PDFPreviewView(url: url, title: resource.title)
										}
									} else if resource.url.hasSuffix(".docx") || resource.url.hasSuffix(".doc") {
										if let url = URL(string: resource.url) {
											StandardWebView(url: url)
												.navigationBarTitle(resource.title, displayMode: .inline)
										}
									} else {
										if let url = URL(string: resource.url) {
											StandardWebView(url: url)
												.navigationBarTitle(resource.title, displayMode: .inline)
										}
									}
								}) {
									HStack {
										// Show appropriate icon based on file type
										if resource.url.hasSuffix(".pdf") {
											Image(systemName: "doc.fill")
												.foregroundColor(.red)
										} else if resource.url.hasSuffix(".docx") || resource.url.hasSuffix(".doc") {
											Image(systemName: "doc.text.fill")
												.foregroundColor(.blue)
										} else {
											Image(systemName: "link")
												.foregroundColor(.gray)
										}
										
										Text(resource.title)
											.foregroundColor(.primary)
									}
									.padding(.vertical, 4)
								}
							}
						}
					}
					
					// Add a refresh button if not loading
					if !isLoading {
						VStack {
							Spacer()
							HStack {
								Spacer()
								Button(action: {
									fetchSafetyResources()
								}) {
									Image(systemName: "arrow.clockwise.circle.fill")
										.font(.system(size: 24))
										.foregroundColor(.red)
										.padding()
										.background(Circle().fill(Color.white.opacity(0.9)))
										.shadow(radius: 3)
								}
								.padding(.trailing, 20)
								.padding(.bottom, 20)
							}
						}
					}
				}
			}
			.navigationBarTitle("Safety Resources", displayMode: .inline)
			.navigationBarItems(trailing: Button("Done") {
				showingSafetyResourcesList = false
			})
		}
		.accentColor(.red)
		.onAppear {
			if safetyResources.isEmpty {
				fetchSafetyResources()
			}
		}
	}
	
	// MARK: - Helper to create WebView sheet
	private func webViewSheet(title: String, url: URL) -> some View {
		NavigationView {
			StandardWebView(url: url)
				.navigationBarTitle(title, displayMode: .inline)
				.navigationBarItems(trailing: Button("Done") {
					showingWebView = false
				})
		}
		.accentColor(.red)
	}
	
	// MARK: - Helper to create PDF View sheet
	private func pdfViewSheet(title: String, url: URL) -> some View {
		NavigationView {
			PDFPreviewView(url: url, title: title)
				.navigationBarTitle(title, displayMode: .inline)
				.navigationBarItems(trailing: Button("Done") {
					showingPDFView = false
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
	
	// MARK: - Social button builder
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
	
	// MARK: - Simplified app launcher
	private func launchAppOrStore(appName: String, appURLString: String, appStoreId: String) {
		let appStoreURL = URL(string: "https://apps.apple.com/app/\(appStoreId)")!
		
		print("🚀 Attempting to launch \(appName)...")
		
		// Try to launch the app directly without checking if it's installed
		if let appURL = URL(string: appURLString) {
			// Use UIApplication.shared.open with a completion handler
			UIApplication.shared.open(appURL, options: [:]) { success in
				if success {
					print("✅ Successfully launched \(appName)")
				} else {
					print("❌ Could not launch \(appName), showing App Store prompt")
					
					// App couldn't be opened, show App Store prompt
					DispatchQueue.main.async {
						self.appToInstall = appName
						self.appStoreURL = appStoreURL
						self.showingAppStoreAlert = true
					}
				}
			}
		} else {
			// Fallback to App Store prompt
			print("⚠️ Invalid URL, showing App Store prompt")
			appToInstall = appName
			self.appStoreURL = appStoreURL
			showingAppStoreAlert = true
		}
	}
}

struct CoachResourcesView_Previews: PreviewProvider {
	static var previews: some View {
		CoachResourcesView()
	}
}
