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