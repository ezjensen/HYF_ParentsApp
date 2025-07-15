//
//  SevenVSevenView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/15/25.
//

import SwiftUI

struct SevenVSevenView: View {
	var body: some View {
		NavigationView {
			ZStack {
				Color.black.ignoresSafeArea()
				
				GeometryReader { geometry in
					VStack(spacing: 0) {
						BannerView(geometry: geometry)
						
						VStack {
							Spacer()
							VStack {
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
								.scrollContentBackground(.hidden)
							}
							.padding(.vertical, 30)
							.padding(.horizontal, 20)
							.background(.ultraThinMaterial)
							.cornerRadius(24)
							.shadow(color: Color.black.opacity(0.15), radius: 10, y: 5)
							.padding(.horizontal, 20)
							Spacer()
						}
						.frame(height: geometry.size.height * 0.7)
					}
				}
			}
			.navigationTitle("7v7")
		}
	}
}
