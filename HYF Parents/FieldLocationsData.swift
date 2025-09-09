//
//  FieldLocationsData.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/18/25.
//

import Foundation
import SwiftUI
import Combine
import Supabase

// Model for Football Fields
struct Field: Identifiable, Codable {
	var id: Int
	var name: String
	var address: String
	var is_home_field: Bool
	var notes: String?
	
	enum CodingKeys: String, CodingKey {
		case id
		case name = "FieldName"  //MUST match Supabase column names
		case address = "FieldAddress"
		case is_home_field = "isHomeField"
		case notes = "FieldNotes"
	}
}

// Custom CodingKey implementation for key decoding strategy
private struct CustomCodingKey: CodingKey {
	var stringValue: String
	var intValue: Int?
	
	init?(stringValue: String) {
		self.stringValue = stringValue
		self.intValue = nil
	}
	
	init?(intValue: Int) {
		self.stringValue = "\(intValue)"
		self.intValue = intValue
	}
}

// Service to fetch fields from Supabase as a shared singleton
class FieldService: ObservableObject {
	@Published var fields: [Field] = []
	@Published var isLoading = false
	@Published var isDataFromSupabase = true
	
	// Singleton instance
	static let shared = FieldService()
	
	// Private initializer for singleton pattern
	private init() {
		// Fields will be loaded when needed
	}
	
	func loadFields() {
		isLoading = true
		
		// Set a timeout to use fallback data if Supabase is slow
		DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
			if self?.isLoading == true {
				print("FieldService: Timeout reached, using fallback data")
				self?.isLoading = false
				self?.isDataFromSupabase = false
				self?.fields = FieldLocationsData.fields.sorted(by: { $0.name < $1.name })
			}
		}
		
		// Fetch data from Supabase
		Task { @MainActor [weak self] in
			guard let self = self else { return }
			
			do {
				let response: PostgrestResponse = try await supabase
					.from("FootballFields")
					.select()
					.execute()
				
				let data = response.data
				
				// Print the raw JSON for debugging
				if let jsonString = String(data: data, encoding: .utf8) {
					print("Raw JSON from Supabase: \(jsonString)")
				}
				
				do {
					let decoder = JSONDecoder()
					decoder.keyDecodingStrategy = .custom { keys in
						let lastKey = keys.last!
						
						// Check if the last key is CodingKeys.name
						if lastKey.stringValue == "name" {
							// Return a key that matches "FieldName" in the JSON
							return CustomCodingKey(stringValue: "FieldName")!
						}
						
						// For all other keys, return the last key
						return lastKey
					}
					
					// Try to decode with custom decoder settings
					let fields = try decoder.decode([Field].self, from: data)
					
					print("FieldService: Loaded \(fields.count) fields from Supabase")
					self.isLoading = false
					
					if fields.isEmpty {
						self.fields = FieldLocationsData.fields.sorted(by: { $0.name < $1.name })
						self.isDataFromSupabase = false
					} else {
						self.fields = fields.sorted(by: { $0.name < $1.name })
						self.isDataFromSupabase = true
					}
				} catch {
					print("FieldService: Error decoding fields: \(error)")
					self.isLoading = false
					self.isDataFromSupabase = false
					self.fields = FieldLocationsData.fields.sorted(by: { $0.name < $1.name })
				}
			} catch {
				print("FieldService: Error fetching fields from Supabase: \(error)")
				self.isLoading = false
				self.isDataFromSupabase = false
				self.fields = FieldLocationsData.fields.sorted(by: { $0.name < $1.name })
			}
		}
	}
}

// MARK: - Static data for fallback
// Static field data for fallback
struct FieldLocationsData {
	static let fields: [Field] = [
		Field(id: 1, name: "Ameche Field", address: "8560 26th Avenue Kenosha, WI 53143", is_home_field: false, notes: nil),
		// ... remaining fields omitted for brevity
	]
	
	// Add fieldsJSON property to convert fields to JSON string
	static var fieldsJSON: String {
		do {
			let encoder = JSONEncoder()
			let data = try encoder.encode(fields)
			if let jsonString = String(data: data, encoding: .utf8) {
				return jsonString
			} else {
				print("Error converting fields data to string")
				return "[]"
			}
		} catch {
			print("Error encoding fields: \(error)")
			return "[]"
		}
	}
}
