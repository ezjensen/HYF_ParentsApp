//
//  getFieldLocations.swift
//  HYF Parents
//
//  Created by Eric Jensen on 9/8/25.
//

import Foundation
import SwiftUI
import WebKit
import Supabase

// Function to pre-fetch field locations from Supabase
func getFieldLocations() {
	// Use the shared singleton to load fields
	if FieldService.shared.fields.isEmpty {
		print("Pre-fetching field locations for WebView")
		FieldService.shared.loadFields()
	} else {
		print("Field locations already loaded: \(FieldService.shared.fields.count) fields available")
	}
}

// Function to send fields data to a WebView
func sendFieldsDataToWebView(_ webView: WKWebView) {
	// Get fields from the shared service
	let fields = FieldService.shared.fields.isEmpty ?
	FieldLocationsData.fields : FieldService.shared.fields
	
	// Convert fields to JSON
	do {
		let encoder = JSONEncoder()
		let fieldsData = try encoder.encode(fields)
		if let fieldsJson = String(data: fieldsData, encoding: .utf8) {
			// Send fields data to JavaScript, escape single quotes
			let script = "receiveFieldsData('\(fieldsJson.replacingOccurrences(of: "'", with: "\\'"))');"
			webView.evaluateJavaScript(script) { result, error in
				if let error = error {
					print("Error sending fields data: \(error)")
					sendHardcodedFieldsToWebView(webView)
				} else {
					print("Fields data sent successfully")
				}
			}
		}
	} catch {
		print("Error encoding fields: \(error.localizedDescription)")
		sendHardcodedFieldsToWebView(webView)
	}
}

// Function to send hardcoded fields as a fallback
func sendHardcodedFieldsToWebView(_ webView: WKWebView) {
	// Use the static fallback data for fields
	let fieldsJSON = FieldLocationsData.fieldsJSON
	
	// Escape single quotes to prevent JavaScript errors
	let escapedJSON = fieldsJSON.replacingOccurrences(of: "'", with: "\\'")
	
	let script = "receiveFieldsData('\(escapedJSON)');"
	webView.evaluateJavaScript(script) { result, error in
		if let error = error {
			print("Error sending hardcoded fields data: \(error)")
			
			// Alternative approach if the first fails
			let directScript = "fieldsData = \(fieldsJSON); checkDataAndRender();"
			webView.evaluateJavaScript(directScript) { result, error in
				if let error = error {
					print("Error with direct field data assignment: \(error)")
				} else {
					print("Direct fields data assignment successful")
				}
			}
		} else {
			print("Hardcoded fields data sent successfully")
		}
	}
}
