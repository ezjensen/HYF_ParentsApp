//
//  ShareSheet.swift
//  HYF Parents
//
//  Created by Eric Jensen on 9/5/25.
//

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
	var items: [Any]
	
	func makeUIViewController(context: Context) -> UIActivityViewController {
		let controller = UIActivityViewController(
			activityItems: items,
			applicationActivities: nil
		)
		return controller
	}
	
	func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
