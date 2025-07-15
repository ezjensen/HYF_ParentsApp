//
//  WeatherAlertsView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/15/25.
//

import SwiftUI
import WebKit

struct WeatherAlertsView: View {
    @Environment(\.openURL) var openURL
    
    @State private var selectedSchool = "Marlowe Middle School"
    let schools = [
        "Marlowe Middle School",
        "Huntley High School",
        "Heineman Middle School"
    ]
    let schoolURLs: [String: String] = [
        "Marlowe Middle School": "https://widget.perryweather.com/?id=e2f730aa-4287-41fe-aec3-abae3744f3e0",
        "Huntley High School": "https://widget.perryweather.com/?id=d72c3842-7563-45a6-9d4e-100bca0f486b",
        "Heineman Middle School": "https://widget.perryweather.com/?id=ba915411-4571-4425-90e2-94335cbac894"
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    BannerView(geometry: geometry)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Choose a location:")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.leading, 10)
                        Picker("Select School", selection: $selectedSchool) {
                            ForEach(schools, id: \.self) { school in
                                Text(school)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal, 20)
                        
                        if let urlString = schoolURLs[selectedSchool], let url = URL(string: urlString) {
                            WebView(url: url)
                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.73)
                                .cornerRadius(16)
                                .padding(.top, 16)
                                .padding(.horizontal, geometry.size.width * 0.05)
                        }
                    }
                    .frame(height: geometry.size.height * 0.85)
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
            }
        }
        .navigationTitle("Weather Alerts")
        .navigationBarTitleDisplayMode(.inline)
    }
}

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