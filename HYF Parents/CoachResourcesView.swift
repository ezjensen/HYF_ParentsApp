//
//  CoachResourcesView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/18/25.
//

import SwiftUI
import WebKit
import PDFKit

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
	
	let columns = [
		GridItem(.fixed(100), spacing: 60),
		GridItem(.fixed(100), spacing: 60)
	]
	
	// Safety resource documents
	let safetyResources = [
		(title: "10 Questions About Head Safety", url: "https://cdn1.sportngin.com/attachments/document/6e68-2618765/10_questions_about_head_safety.pdf"),
		(title: "Heat and Hydration Guidelines", url: "https://cdn1.sportngin.com/attachments/document/abf1-2618766/Heat_And_Hydration_Guidelines.pdf"),
		(title: "TCYFL Concussion Flow Chart", url: "https://cdn1.sportngin.com/attachments/document/c0a4-2618767/TCYFL_Concussion_Flow_Chart_.pdf"),
		(title: "TCYFL Concussion Policy", url: "https://cdn1.sportngin.com/attachments/document/33f3-2618769/TCYFL_Concussion_Policy.docx")
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
										// TCYFL Passport button
										Button(action: {
											webViewTitle = "TCYFL Passport"
											webViewURL = URL(string: "https://tcyfl.athleticpassports.com/login")
											showingWebView = true
										}) {
											mainButtonView(image: "icon_TCYFL", label: "TCYFL Passport", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										// Safety Resources button - Now shows a list
										Button(action: {
											showingSafetyResourcesList = true
										}) {
											mainButtonView(image: "icon_HYF_Safety", label: "Safety Resources", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										// Glazier Drive button
										Button(action: {
											checkAndOpenApp(
												appName: "Glazier Drive",
												appStoreId: "id1530106966"
											)
										}) {
											mainButtonView(image: "icon_GlazierDrive", label: "Glazier Drive", bg: Color.white.opacity(1.0), fg: .black)
										}
										
										// Playmaker X button
										Button(action: {
											checkAndOpenApp(
												appName: "Playmaker X",
												appStoreId: "id1466963180"
											)
										}) {
											mainButtonView(image: "icon_PlaymakerX", label: "Playmaker X", bg: Color.white.opacity(1.0), fg: .black)
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
	}
	
	// MARK: - Safety Resources List View
	// MARK: - Safety Resources List View
	private func safetyResourcesListView() -> some View {
		NavigationView {
			List {
				ForEach(safetyResources, id: \.title) { resource in
					Button(action: {
						selectedPDFTitle = resource.title
						
						// Check if it's a PDF or DOCX file
						if resource.url.hasSuffix(".pdf") {
							selectedPDFURL = URL(string: resource.url)
							showingPDFView = true
						} else if resource.url.hasSuffix(".docx") || resource.url.hasSuffix(".doc") {
							// Use Microsoft's Office web viewer for Word documents
							let docURL = resource.url
							let encodedURL = docURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? docURL
							let viewerURL = "https://view.officeapps.live.com/op/view.aspx?src=\(encodedURL)"
							
							webViewTitle = resource.title
							webViewURL = URL(string: viewerURL)
							showingWebView = true
						} else {
							// Fall back to regular webview for other file types
							webViewTitle = resource.title
							webViewURL = URL(string: resource.url)
							showingWebView = true
						}
						
						showingSafetyResourcesList = false
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
							Spacer()
							Image(systemName: "chevron.right")
								.foregroundColor(.gray)
								.font(.caption)
						}
						.padding(.vertical, 4)
					}
				}
			}
			.navigationBarTitle("Safety Resources", displayMode: .inline)
			.navigationBarItems(trailing: Button("Done") {
				showingSafetyResourcesList = false
			})
		}
		.accentColor(.red)
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
			PDFPreviewView(url: url)
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
	
	// MARK: - Check if app is installed, otherwise prompt to install
	private func checkAndOpenApp(appName: String, appStoreId: String) {
		// Direct deep links that might work for these specific apps
		var appDeepLink: URL?
		
		switch appName {
			case "Glazier Drive":
				// Try multiple potential deep links for Glazier Drive
				let potentialLinks = ["glazier://", "glazierdrive://", "com.hudl.glazier://"]
				for link in potentialLinks {
					if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
						appDeepLink = url
						break
					}
				}
			case "Playmaker X":
				// Try multiple potential deep links for Playmaker X
				let potentialLinks = ["playmakerx://", "playmaker://", "com.playmakercoach.x://"]
				for link in potentialLinks {
					if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
						appDeepLink = url
						break
					}
				}
			default:
				break
		}
		
		// If we found a working deep link, use it
		if let deepLink = appDeepLink {
			UIApplication.shared.open(deepLink, options: [:]) { success in
				print("Opened \(appName) with deep link: \(success)")
			}
		} else {
			// Otherwise go directly to App Store
			if let appStoreURL = URL(string: "https://apps.apple.com/app/\(appStoreId)") {
				UIApplication.shared.open(appStoreURL, options: [:]) { _ in
					print("Opened App Store for \(appName)")
				}
			}
		}
	}
	
	private func openAppWithUniversalLink(appName: String, appStoreId: String) {
		// First try Universal Links for these specific apps
		var universalLinkURL: URL?
		
		if appName == "Glazier Drive" {
			universalLinkURL = URL(string: "https://drive.glazier.io")
		} else if appName == "Playmaker X" {
			universalLinkURL = URL(string: "https://app.playmakerx.com")
		}
		
		// Try to open with universal link if available
		if let universalLink = universalLinkURL {
			UIApplication.shared.open(universalLink, options: [:]) { success in
				if !success {
					// Fall back to App Store link if universal link fails
					if let appStoreURL = URL(string: "https://apps.apple.com/app/\(appStoreId)") {
						UIApplication.shared.open(appStoreURL, options: [:]) { _ in }
					}
				}
			}
		} else {
			// Use App Store URL as fallback
			if let appStoreURL = URL(string: "https://apps.apple.com/app/\(appStoreId)") {
				UIApplication.shared.open(appStoreURL, options: [:]) { _ in }
			}
		}
	}
	
	// Helper method to show App Store prompt
	private func showAppStorePrompt(appName: String, appStoreId: String) {
		appToInstall = appName
		appStoreURL = URL(string: "https://apps.apple.com/app/\(appStoreId)")
		showingAppStoreAlert = true
	}
	
	private func tryOpenApp(appName: String, urlSchemes: [String], appStoreId: String) {
		// Try a more direct approach with specific app identifiers
		let appURLs: [String: String] = [
			"Glazier Drive": "glazierdrive://login",
			"Playmaker X": "playmakerx://home"
		]
		
		// First try with the direct app URL if available
		if let directURL = appURLs[appName],
		   let url = URL(string: directURL) {
			print("Trying direct URL: \(directURL)")
			
			// Check if we can open it
			if UIApplication.shared.canOpenURL(url) {
				print("✅ Direct URL can be opened")
				UIApplication.shared.open(url, options: [:]) { success in
					if !success {
						print("❌ Direct URL open failed")
						self.showAppStorePrompt(appName: appName, appStoreId: appStoreId)
					} else {
						print("✅ App opened successfully")
					}
				}
				return
			} else {
				print("❌ Cannot open direct URL")
			}
		}
		
		// If no direct URL or it failed, try the app store
		print("Showing App Store prompt for \(appName)")
		showAppStorePrompt(appName: appName, appStoreId: appStoreId)
	}
}

struct CoachResourcesView_Previews: PreviewProvider {
	static var previews: some View {
		CoachResourcesView()
	}
}
