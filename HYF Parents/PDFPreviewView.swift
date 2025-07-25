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
	@State private var isLoading = true
	@State private var loadError: Error? = nil
	
	init(url: URL, title: String = "PDF Document") {
		self.url = url
		self.title = title
	}
	
	var body: some View {
		ZStack {
			// PDF viewer
			PDFKitView(url: url, searchSelection: nil, isLoading: $isLoading, loadError: $loadError)
			
			// Loading overlay
			if isLoading {
				VStack {
					ProgressView()
						.scaleEffect(1.5)
						.progressViewStyle(CircularProgressViewStyle(tint: .red))
						.padding()
					Text("Loading PDF...")
						.foregroundColor(.primary)
						.padding(.top, 8)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Color.black.opacity(0.1))
			}
			
			// Error overlay
			if let error = loadError {
				VStack(spacing: 16) {
					Image(systemName: "exclamationmark.triangle.fill")
						.resizable()
						.scaledToFit()
						.frame(width: 60, height: 60)
						.foregroundColor(.red)
					
					Text("Failed to load PDF")
						.font(.headline)
					
					Text(error.localizedDescription)
						.font(.subheadline)
						.multilineTextAlignment(.center)
						.foregroundColor(.secondary)
						.padding(.horizontal)
					
					Button(action: {
						isLoading = true
						loadError = nil
						// Force reload after a short delay
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
							// This will trigger updateUIView again
							isLoading = false
						}
					}) {
						Text("Try Again")
							.foregroundColor(.white)
							.padding(.horizontal, 20)
							.padding(.vertical, 10)
							.background(Color.red)
							.cornerRadius(8)
					}
					.padding(.top, 8)
				}
				.padding()
				.background(Color(.systemBackground).opacity(0.9))
				.cornerRadius(16)
				.shadow(radius: 10)
			}
		}
		.navigationTitle(title)
		.navigationBarTitleDisplayMode(.inline)
	}
}

struct PDFKitView: UIViewRepresentable {
	let url: URL
	var searchSelection: PDFSelection?
	@Binding var isLoading: Bool
	@Binding var loadError: Error?
	
	// Add a cache manager to avoid repeatedly downloading the same PDF
	private static let pdfCache = NSCache<NSURL, PDFDocument>()
	
	func makeUIView(context: Context) -> PDFView {
		let pdfView = PDFView()
		pdfView.autoScales = true
		pdfView.displayMode = .singlePage
		pdfView.displayDirection = .vertical
		pdfView.usePageViewController(true)
		pdfView.delegate = context.coordinator
		
		// Immediately mark as loading when creating the view
		isLoading = true
		
		// Use the cache or load document
		loadPDFDocument(pdfView: pdfView)
		
		return pdfView
	}
	
	private func loadPDFDocument(pdfView: PDFView) {
		// Check if we have a cached version first
		if let cachedDocument = Self.pdfCache.object(forKey: url as NSURL) {
			// Use cached document
			DispatchQueue.main.async {
				pdfView.document = cachedDocument
				self.isLoading = false
			}
			return
		}
		
		// Otherwise load it with priority
		let loadTask = DispatchWorkItem {
			do {
				// Add a timeout for network operations
				let sessionConfig = URLSessionConfiguration.default
				sessionConfig.timeoutIntervalForRequest = 30.0
				sessionConfig.timeoutIntervalForResource = 60.0
				let session = URLSession(configuration: sessionConfig)
				
				// Create a data task to download the PDF
				let downloadTask = session.dataTask(with: url) { data, response, error in
					if let error = error {
						DispatchQueue.main.async {
							self.loadError = error
							self.isLoading = false
						}
						return
					}
					
					guard let data = data else {
						DispatchQueue.main.async {
							self.loadError = NSError(domain: "PDFKitView", code: 1,
													 userInfo: [NSLocalizedDescriptionKey: "No data received"])
							self.isLoading = false
						}
						return
					}
					
					// Create document from data
					if let document = PDFDocument(data: data) {
						// Cache the document for future use
						Self.pdfCache.setObject(document, forKey: url as NSURL)
						
						// Update UI on the main thread
						DispatchQueue.main.async {
							pdfView.document = document
							self.isLoading = false
						}
					} else {
						DispatchQueue.main.async {
							self.loadError = NSError(domain: "PDFKitView", code: 2,
													 userInfo: [NSLocalizedDescriptionKey: "Could not create PDF from data"])
							self.isLoading = false
						}
					}
				}
				
				// Start the download
				downloadTask.resume()
				
			} catch {
				DispatchQueue.main.async {
					self.loadError = error
					self.isLoading = false
				}
			}
		}
		
		// Execute with user-initiated priority
		DispatchQueue.global(qos: .userInitiated).async(execute: loadTask)
	}
	
	func updateUIView(_ pdfView: PDFView, context: Context) {
		// Only handle search selection if document is loaded
		if pdfView.document != nil {
			context.coordinator.handleSearchSelection(pdfView, selection: searchSelection)
		}
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, PDFViewDelegate {
		let parent: PDFKitView
		private var lastProcessedSelection: PDFSelection? = nil
		
		init(_ parent: PDFKitView) {
			self.parent = parent
		}
		
		// Rest of your coordinator implementation remains unchanged
		func handleSearchSelection(_ pdfView: PDFView, selection: PDFSelection?) {
			// Your existing implementation
		}
		
		private func clearHighlights(in pdfView: PDFView) {
			// Your existing implementation
		}
	}
}
