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
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    BannerView(geometry: geometry)
                    
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
                }
            }
            .navigationTitle("7v7")
        }
    }
}