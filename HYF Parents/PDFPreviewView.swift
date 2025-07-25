//
//  PDFPreviewView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/15/25.
//

import SwiftUI
import PDFKit

struct PDFPreviewView: View {
	let url: URL
	var title: String
	@State private var searchText: String = ""
	@State private var searchResults: [PDFSelection] = []
	@State private var currentResultIndex: Int = 0
	
	// Add a default parameter for title
	init(url: URL, title: String = "PDF Document") {
		self.url = url
		self.title = title
	}
	
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
		.navigationTitle(title)
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
		
		// Configure for better viewing
		pdfView.displayMode = .singlePage
		pdfView.displayDirection = .vertical
		pdfView.usePageViewController(true)
		
		if let document = PDFDocument(url: url) {
			pdfView.document = document
		}
		return pdfView
	}
	
	func updateUIView(_ pdfView: PDFView, context: Context) {
		if let selection = searchSelection {
			// Clear any previous highlights
			if let document = pdfView.document {
				for i in 0..<document.pageCount {
					if let page = document.page(at: i) {
						for annotation in page.annotations {
							// Compare strings properly
							if annotation.type == PDFAnnotationSubtype.highlight.rawValue {
								page.removeAnnotation(annotation)
							}
						}
					}
				}
			}
			
			// Create a highlight annotation
			if let page = selection.pages.first {
				// Get the bounds for this selection on this specific page
				let pageBounds = selection.bounds(for: page)
				
				// Create highlight annotation with proper properties
				let highlightAnnotation = PDFAnnotation(bounds: pageBounds, forType: .highlight, withProperties: nil)
				highlightAnnotation.color = UIColor.yellow.withAlphaComponent(0.5)
				page.addAnnotation(highlightAnnotation)
				
				// Go to the page containing the result
				pdfView.go(to: selection)
				
				// Set the display to properly show the selection
				let point = CGPoint(x: pageBounds.midX, y: pageBounds.midY)
				pdfView.go(to: PDFDestination(page: page, at: point))
			}
		}
	}
}
