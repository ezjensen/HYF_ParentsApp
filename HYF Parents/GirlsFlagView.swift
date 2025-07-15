//
//  GirlsFlagView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/15/25.
//

import SwiftUI

struct GirlsFlagView: View {
<<<<<<< Updated upstream
    var body: some View {
        NavigationView {
            ZStack {
                Image("FootballField_Girls")
                    .resizable()
                    .opacity(0.6)
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        BannerView(geometry: geometry)
						
                        List {
                            Text("League Calendar (Coming Soon)")
                            Text("Field Maps (Coming Soon)")
                            Section(header: Text("League Rules")) {
                                NavigationLink("League Rules") {
                                    PDFPreviewView(url: URL(string: "https://www.tcyfl.net/grabit.php?file=TCYFL_Girls_Fall_Flag_Rules_2024.pdf")!)
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    }
                }
            }
            .navigationTitle("Girls Flag")
        }
    }
=======
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
									Text("League Calendar (Coming Soon)")
									Text("Field Maps (Coming Soon)")
									Section(header: Text("League Rules")) {
										NavigationLink("League Rules") {
											PDFPreviewView(url: URL(string: "https://www.tcyfl.net/grabit.php?file=TCYFL_Girls_Fall_Flag_Rules_2024.pdf")!)
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
			.navigationTitle("Girls Flag")
		}
	}
>>>>>>> Stashed changes
}
