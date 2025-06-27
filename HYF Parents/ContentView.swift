//
//  ContentView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 6/20/25.
//

import SwiftUI
import WebKit
import PDFKit


//MARK: Main ContentView with TabView
struct ContentView: View {
	var body: some View {
		TabView {
			MainScreenView()
				.tabItem {
					Image(systemName: "house.fill")
					Text("Home")
				}
			TackleView()
				.tabItem {
					Image(systemName: "sportscourt")
					Text("Tackle")
				}
			SevenVSevenView()
				.tabItem {
					Image(systemName: "person.3.fill")
					Text("7v7")
				}
			GirlsFlagView()
				.tabItem {
					Image(systemName: "flag.fill")
					Text("Girls Flag")
				}
		}
		.accentColor(.red)
		.onAppear {
			let appearance = UITabBarAppearance()
			appearance.configureWithOpaqueBackground()
			appearance.backgroundColor = UIColor.systemGray6 // or any dark color
			UITabBar.appearance().standardAppearance = appearance
			if #available(iOS 15.0, *) {
				UITabBar.appearance().scrollEdgeAppearance = appearance
			}
		}
	}
}

//MARK: PDF Previewer
struct PDFPreviewView: View {
	let url: URL
	@State private var searchText: String = ""
	@State private var searchResults: [PDFSelection] = []
	@State private var currentResultIndex: Int = 0
	
	var body: some View {
		VStack {
			HStack {
				TextField("Search PDF", text: $searchText, onCommit: {
					searchPDF()
				})
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.padding(.horizontal)
				
				if !searchResults.isEmpty {
					Button("Prev") {
						goToResult(offset: -1)
					}
					Button("Next") {
						goToResult(offset: 1)
					}
					Text("\(currentResultIndex + 1)/\(searchResults.count)")
						.font(.caption)
						.frame(width: 50)
				}
			}
			PDFKitView(url: url, searchSelection: searchResults.isEmpty ? nil : searchResults[currentResultIndex])
		}
		.navigationTitle("League Rules")
		.navigationBarTitleDisplayMode(.inline)
	}
	
	private func searchPDF() {
		guard let document = PDFDocument(url: url), !searchText.isEmpty else {
			searchResults = []
			currentResultIndex = 0
			return
		}
		let matches = document.findString(searchText, withOptions: .caseInsensitive)
		searchResults = matches
		currentResultIndex = 0
	}
	
	private func goToResult(offset: Int) {
		guard !searchResults.isEmpty else { return }
		currentResultIndex = (currentResultIndex + offset + searchResults.count) % searchResults.count
	}
}

struct PDFKitView: UIViewRepresentable {
	let url: URL
	var searchSelection: PDFSelection?
	
	func makeUIView(context: Context) -> PDFView {
		let pdfView = PDFView()
		pdfView.autoScales = true
		if let document = PDFDocument(url: url) {
			pdfView.document = document
		}
		return pdfView
	}
	
	func updateUIView(_ pdfView: PDFView, context: Context) {
		if let selection = searchSelection {
			pdfView.setCurrentSelection(selection, animate: true)
			pdfView.go(to: selection)
		}
	}
}

//MARK: Main Screen with background, logo, and overlay
import SwiftUI
import WebKit

struct MainScreenView: View {
	let columns = [
		GridItem(.fixed(100), spacing: 60), // Adjusted horizontal spacing
		GridItem(.fixed(100), spacing: 60) // Adjusted horizontal spacing
	]
	
	var body: some View {
		ZStack {
			Image("FootballField_H")
				.resizable()
				//.scaledToFill()
				.frame(maxWidth: .infinity, alignment: .leading)
				.opacity(0.6)
				//.ignoresSafeArea()

			VStack {
				Spacer()
				VStack(spacing: 50) { //Increase vertical spacing
					LazyVGrid(columns: columns, spacing: 50) { //Increased horizontal spacing
						
						//Calendar Button
						Button(action: {
							openURL("https://www.huntleyyouthfootball.org/page/show/6967331-important-dates") // Update URL as needed
						}) {
							Image("icon_ImportantDates")
								.resizable()
								.frame(width: 80, height: 80)
								.accessibilityLabel("HYF Important Dates")
						}
						.buttonStyle(.plain)
						
						//Weather Alert Button
						Button(action: {
							openURL("https://widget.perryweather.com/?id=e2f730aa-4287-41fe-aec3-abae3744f3e0")
						}) {
							Image("icon_WeatherAlert")
								.resizable()
								.frame(width: 100, height: 100)
								.accessibilityLabel("Weather Alert")
						}
						.buttonStyle(.plain)
						
						//Registration Button
						Button(action: {
							openURL("https://www.huntleyyouthfootball.org/page/show/6967329-registration")
						}) {
							Image("icon_Registration")
								.resizable()
								.frame(width: 100, height: 100)
								.accessibilityLabel("Registration")
						}
						.buttonStyle(.plain)
						
						//Spirit Store Button
						Button(action: {
							openURL("https://www.huntleyyouthfootball.org/spiritstore")
						}) {
							Image("icon_SpiritStore")
								.resizable()
								.frame(width: 100, height: 100)
								.accessibilityLabel("Spirit Store")
						}
						.buttonStyle(.plain)
												
						//TCYFL Button
						Button(action: {
							openURL("https://www.tcyfl.net/index.php")
						}) {
							Image("icon_TCYFL")
								.resizable()
								.frame(width: 100, height: 100)
								.accessibilityLabel("TCYFL Website")
						}
						.buttonStyle(.plain)
						
						// Fill remaining grid spots for 2x3 layout
						//Color.clear.frame(width: 100, height: 25)
						//Color.clear.frame(width: 100, height: 25)
						//Color.clear.frame(width: 100, height: 25)
					}
					/* //Commented out to test using icon buttons instead of WebView
					Text("Weather Advisory / Alerts")
						.font(.headline)
					WebView(url: URL(string: "https://widget.perryweather.com/?id=e2f730aa-4287-41fe-aec3-abae3744f3e0")!)
						.frame(height: 80)
						.cornerRadius(8)
					 */
				}
				.padding()
				.background(.ultraThinMaterial)
				.cornerRadius(20)
				.padding()
				//Spacer()
			}
		}
	}
	
	private func openURL(_ urlString: String) {
		if let url = URL(string: urlString) {
			UIApplication.shared.open(url)
		}
	}
}


//MARK: Tackle Tab
struct TackleView: View {
	var body: some View {
		NavigationView {
			List {
				Link("League Calendar", destination: URL(string: "https://www.tcyfl.net/index.php?option=com_jevents&task=month.calendar&Itemid=1")!)
				Text("Field Maps (Coming Soon)")
				Section(header: Text("League Rules")) {
					NavigationLink("League Rules") {
						PDFPreviewView(url: URL(string: "https://www.tcyfl.net/grabit.php?file=TCYFL_Football_Playing_Rules_FINAL.pdf")!)
					}
				}
				Text("VEO Camera Link (Coming Soon)")
			}
			.navigationTitle("Tackle")
		}
	}
}

//MARK: 7v7 Tab
struct SevenVSevenView: View {
	var body: some View {
		NavigationView {
			List {
				Link("League Calendar", destination: URL(string: "https://www.tcyfl.net/myschedules7man.php")!)
				Text("Field Maps (Coming Soon)")
				Section(header: Text("League Rules")) {
					NavigationLink("K-3") {
						PDFPreviewView(url: URL(string: "https://www.tcyfl.net/grabit.php?file=2025FINALK3_rules.pdf")!)
					}
					NavigationLink("5-8") {
						PDFPreviewView(url: URL(string: "https://www.tcyfl.net/grabit.php?file=2025FINAL7_7_rules.pdf")!)
					}
				}
			}
			.navigationTitle("7v7")
		}
	}
}

struct GirlsFlagView: View {
	var body: some View {
		NavigationView {
			ZStack {
				Image("FootballField_Girls")
					.resizable()
					//.scaledToFill()
					.opacity(0.6)
					//.ignoresSafeArea()
				List {
					Text("League Calendar (Coming Soon)")
					Text("Field Maps (Coming Soon)")
					Section(header: Text("League Rules")) {
						NavigationLink("League Rules") {
							PDFPreviewView(url: URL(string: "https://www.tcyfl.net/grabit.php?file=TCYFL_Girls_Fall_Flag_Rules_2024.pdf")!)
						}
					}
				}
				.scrollContentBackground(.hidden) // Hides List background
				.background(Color.clear)
			}
			.navigationTitle("Girls Flag")
		}
	}
}

//MARK: Simple WebView for weather widget
struct WebView: UIViewRepresentable {
	let url: URL
	func makeUIView(context: Context) -> WKWebView {
		WKWebView()
	}
	func updateUIView(_ uiView: WKWebView, context: Context) {
		let request = URLRequest(url: url)
		uiView.load(request)
	}
}
