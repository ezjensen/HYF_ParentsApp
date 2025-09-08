//
//  Supabase.swift
//  HYF Parents
//
//  Created by Eric Jensen on 8/11/25.
//

import Foundation
import SwiftUI
import Supabase

let supabase = SupabaseClient(
	supabaseURL: URL(string: "https://dnnkzeghqckuqinlamps.supabase.co")!,
	supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRubmt6ZWdocWNrdXFpbmxhbXBzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ1Nzk4NTcsImV4cCI6MjA3MDE1NTg1N30.upNLACkKXkwZ4nfubPpBEI0YiTWxUCbQ-0rW--pAbrE"
)


// MARK: - Get League Rules

class LeagueRulesStore: ObservableObject {
	@Published var tackleRulesLink: String = ""
	@Published var girlsFlagRulesLink: String = ""
	@Published var sevenOnSevenK3RulesLink: String = ""
	@Published var sevenOnSevenUpperRulesLink: String = ""
	
	@Published var isLoading: Bool = true
	@Published var loadError: Bool = false
	
	static let shared = LeagueRulesStore()
	
	private init() {
		// Private initializer for singleton pattern
		fetchAllRules()
	}
	
	func fetchAllRules() {
		isLoading = true
		loadError = false
		
		Task {
			do {
				// Create a model for the database query
				struct LeagueRule: Codable {
					let program: String
					let programLevel: String
					let rulesLink: String
				}
				
				// Get all rules in a single query
				let allRules: [LeagueRule] = try await supabase
					.from("LeagueRules")
					.select()
					.execute()
					.value
				
				await MainActor.run {
					// Process Tackle rules
					if let rule = allRules.first(where: {
						$0.program == "Tackle" && $0.programLevel == "Tackle"
					}) {
						self.tackleRulesLink = rule.rulesLink
					} else {
						self.tackleRulesLink = "https://www.tcyfl.net/grabit.php?file=TCYFL_Football_Playing_Rules_FINAL.pdf"
					}
					
					// Process Girls Flag rules
					if let rule = allRules.first(where: {
						$0.program == "Girls Flag" && $0.programLevel == "Girls Flag"
					}) {
						self.girlsFlagRulesLink = rule.rulesLink
					} else {
						self.girlsFlagRulesLink = "https://www.tcyfl.net/grabit.php?file=TCYFL_Girls_Fall_Flag_Rules_2024.pdf"
					}
					
					// Process 7v7 K-3 rules
					if let rule = allRules.first(where: {
						$0.program == "7v7" && $0.programLevel == "K-3"
					}) {
						self.sevenOnSevenK3RulesLink = rule.rulesLink
					} else {
						self.sevenOnSevenK3RulesLink = "https://www.tcyfl.net/grabit.php?file=2025FINALK3_rules.pdf"
					}
					
					// Process 7v7 4-8th rules
					if let rule = allRules.first(where: {
						$0.program == "7v7" && $0.programLevel == "4-8th"
					}) {
						self.sevenOnSevenUpperRulesLink = rule.rulesLink
					} else {
						self.sevenOnSevenUpperRulesLink = "https://www.tcyfl.net/grabit.php?file=2025FINAL7_7_rules.pdf"
					}
					
					self.isLoading = false
				}
			} catch {
				print("Error fetching rules: \(error)")
				
				await MainActor.run {
					self.loadError = true
					self.isLoading = false
					
					// Set fallback values
					self.tackleRulesLink = "https://www.tcyfl.net/grabit.php?file=TCYFL_Football_Playing_Rules_FINAL.pdf"
					self.girlsFlagRulesLink = "https://www.tcyfl.net/grabit.php?file=TCYFL_Girls_Fall_Flag_Rules_2024.pdf"
					self.sevenOnSevenK3RulesLink = "https://www.tcyfl.net/grabit.php?file=2025FINALK3_rules.pdf"
					self.sevenOnSevenUpperRulesLink = "https://www.tcyfl.net/grabit.php?file=2025FINAL7_7_rules.pdf"
				}
			}
		}
	}
}
