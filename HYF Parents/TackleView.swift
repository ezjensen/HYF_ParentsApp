//
//  TackleView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/15/25.
//

import SwiftUI

struct TackleView: View {
	var body: some View {
		NavigationView {
			ZStack {
				Color.black.ignoresSafeArea()
				
				GeometryReader { geometry in
					VStack(spacing: 0) {
						BannerView(geometry: geometry)
						// Content starts immediately after banner
						VStack {
							List {
								Link("League Calendar", destination: URL(string: "https://www.tcyfl.net/index.php?option=com_jevents&task=month.calendar&Itemid=1")!)
								Text("Field Maps (Coming Soon)")
								//Section(header: Text("League Rules")) {
									NavigationLink("League Rules") {
										PDFPreviewView(url: URL(string: "https://www.tcyfl.net/grabit.php?file=TCYFL_Football_Playing_Rules_FINAL.pdf")!)
									//}
								}
								Text("VEO Camera Link (Coming Soon)")
							}
							.scrollContentBackground(.hidden)
							.padding(.vertical, 20)
							.padding(.horizontal, 20)
							.background(.ultraThinMaterial)
							.cornerRadius(24)
							.shadow(color: Color.black.opacity(0.15), radius: 10, y: 5)
							.padding(.horizontal, 20)
							.padding(.top, 10)
						}
					}
				}
			}
			Spacer()
			.navigationTitle("Tackle")
		}
		//Spacer()
	}
}
