//
//  getSchedules.swift
//  HYF Parents
//
//  Created by Eric Jensen on 8/11/25.
//

import Foundation
import SwiftUI
import Supabase

class ScheduleStore: ObservableObject {
	// Girls Flag Schedule Links
	@Published var girlsFlag3To5Link: String = ""
	@Published var girlsFlag6To8Link: String = ""
	
	// 7v7 Schedule Links
	@Published var sevenOnSevenK3Link: String = ""
	@Published var sevenOnSeven4To5Link: String = ""
	@Published var sevenOnSeven6To7Link: String = ""
	@Published var sevenOnSeven8Link: String = ""
	
	// Tackle Schedule Links
	@Published var tackleVarsityBIG10Link: String = ""
	@Published var tackleJVBIG10Link: String = ""
	@Published var tackleLightweightBIG10Link: String = ""
	@Published var tackleMiddleweightBIG10Link: String = ""
	@Published var tackleMiddleweightPACLink: String = ""
	@Published var tackleFeatherweightBIG10Link: String = ""
	@Published var tackleFeatherweightPACLink: String = ""
	@Published var tackleBantamBIG10Link: String = ""
	@Published var tackleBantamPACLink: String = ""
	@Published var tackleFlightweightPACLink: String = ""
	
	@Published var isLoading: Bool = true
	@Published var loadError: Bool = false
	
	static let shared = ScheduleStore()
	
	private init() {
		// Private initializer for singleton pattern
		fetchAllSchedules()
	}
	
	func fetchAllSchedules() {
		isLoading = true
		loadError = false
		
		Task {
			do {
				// Create a model for the database query
				struct Schedule: Codable {
					let program: String
					let programLevel: String
					let programDivision: String?
					let tcyflLink: String
					
					enum CodingKeys: String, CodingKey {
						case program = "Program"
						case programLevel = "ProgramLevel"
						case programDivision = "ProgramDivision"
						case tcyflLink = "TCYFL_Link"
					}
				}
				
				// Get all schedules in a single query
				let allSchedules: [Schedule] = try await supabase
					.from("TCYFLSchedules")
					.select()
					.execute()
					.value
				
				await MainActor.run {
					// Process Girls Flag schedules
					let girlsFlagSchedules = allSchedules.filter { $0.program == "Girls Flag" }
					
					// 3-5th Girls Flag
					if let schedule = girlsFlagSchedules.first(where: { $0.programLevel == "3-5th" }) {
						self.girlsFlag3To5Link = schedule.tcyflLink
					} else {
						self.girlsFlag3To5Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=7man&division=4-5th"
					}
					
					// 6-8th Girls Flag
					if let schedule = girlsFlagSchedules.first(where: { $0.programLevel == "6-8th" }) {
						self.girlsFlag6To8Link = schedule.tcyflLink
					} else {
						self.girlsFlag6To8Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=7man&division=6-8th"
					}
					
					// Process 7v7 schedules
					let sevenVSevenSchedules = allSchedules.filter { $0.program == "7v7" }
					
					// K-3 7v7
					if let schedule = sevenVSevenSchedules.first(where: { $0.programLevel == "K-3" }) {
						self.sevenOnSevenK3Link = schedule.tcyflLink
					} else {
						self.sevenOnSevenK3Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=7man&division=K3"
					}
					
					// 4-5th 7v7
					if let schedule = sevenVSevenSchedules.first(where: { $0.programLevel == "4-5th" }) {
						self.sevenOnSeven4To5Link = schedule.tcyflLink
					} else {
						self.sevenOnSeven4To5Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=7man&division=4-5th"
					}
					
					// 6-7th 7v7
					if let schedule = sevenVSevenSchedules.first(where: { $0.programLevel == "6-7th" }) {
						self.sevenOnSeven6To7Link = schedule.tcyflLink
					} else {
						self.sevenOnSeven6To7Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=7man&division=6-7th"
					}
					
					// 8th 7v7
					if let schedule = sevenVSevenSchedules.first(where: { $0.programLevel == "8th" }) {
						self.sevenOnSeven8Link = schedule.tcyflLink
					} else {
						self.sevenOnSeven8Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=7man&division=8th"
					}
					
					// Process Tackle schedules
					let tackleSchedules = allSchedules.filter { $0.program == "Tackle" }
					
					// Varsity - BIG 10
					if let schedule = tackleSchedules.first(where: {
						$0.programLevel == "Varsity" && $0.programDivision == "BIG10"
					}) {
						self.tackleVarsityBIG10Link = schedule.tcyflLink
					} else {
						self.tackleVarsityBIG10Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=varsity"
					}
					
					// JV - BIG 10
					if let schedule = tackleSchedules.first(where: {
						$0.programLevel == "JV" && $0.programDivision == "BIG10"
					}) {
						self.tackleJVBIG10Link = schedule.tcyflLink
					} else {
						self.tackleJVBIG10Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=jv"
					}
					
					// Lightweight - BIG 10
					if let schedule = tackleSchedules.first(where: {
						$0.programLevel == "Lightweight" && $0.programDivision == "BIG10"
					}) {
						self.tackleLightweightBIG10Link = schedule.tcyflLink
					} else {
						self.tackleLightweightBIG10Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=lightweight"
					}
					
					// Middleweight - BIG 10
					if let schedule = tackleSchedules.first(where: {
						$0.programLevel == "Middleweight" && $0.programDivision == "BIG10"
					}) {
						self.tackleMiddleweightBIG10Link = schedule.tcyflLink
					} else {
						self.tackleMiddleweightBIG10Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=middleweight"
					}
					
					// Middleweight - PAC
					if let schedule = tackleSchedules.first(where: {
						$0.programLevel == "Middleweight" && $0.programDivision == "PAC"
					}) {
						self.tackleMiddleweightPACLink = schedule.tcyflLink
					} else {
						self.tackleMiddleweightPACLink = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=middleweight"
					}
					
					// Featherweight - BIG 10
					if let schedule = tackleSchedules.first(where: {
						$0.programLevel == "Featherweight" && $0.programDivision == "BIG10"
					}) {
						self.tackleFeatherweightBIG10Link = schedule.tcyflLink
					} else {
						self.tackleFeatherweightBIG10Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=feather"
					}
					
					// Featherweight - PAC
					if let schedule = tackleSchedules.first(where: {
						$0.programLevel == "Featherweight" && $0.programDivision == "PAC"
					}) {
						self.tackleFeatherweightPACLink = schedule.tcyflLink
					} else {
						self.tackleFeatherweightPACLink = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=featherweight"
					}
					
					// Bantam - BIG 10
					if let schedule = tackleSchedules.first(where: {
						$0.programLevel == "Bantam" && $0.programDivision == "BIG10"
					}) {
						self.tackleBantamBIG10Link = schedule.tcyflLink
					} else {
						self.tackleBantamBIG10Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=bantam"
					}
					
					// Bantam - PAC
					if let schedule = tackleSchedules.first(where: {
						$0.programLevel == "Bantam" && $0.programDivision == "PAC"
					}) {
						self.tackleBantamPACLink = schedule.tcyflLink
					} else {
						self.tackleBantamPACLink = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=bantam"
					}
					
					// Flyweight - PAC
					if let schedule = tackleSchedules.first(where: {
						$0.programLevel == "Flyweight" && $0.programDivision == "PAC"
					}) {
						self.tackleFlightweightPACLink = schedule.tcyflLink
					} else {
						self.tackleFlightweightPACLink = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=flyweight"
					}
					
					self.isLoading = false
				}
			} catch {
				print("Error fetching schedules: \(error)")
				
				await MainActor.run {
					self.loadError = true
					self.isLoading = false
					
					// Set fallback values for Girls Flag
					self.girlsFlag3To5Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=7man&division=4-5th"
					self.girlsFlag6To8Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=7man&division=6-8th"
					
					// Set fallback values for 7v7
					self.sevenOnSevenK3Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=7man&division=K3"
					self.sevenOnSeven4To5Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=7man&division=4-5th"
					self.sevenOnSeven6To7Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=7man&division=6-7th"
					self.sevenOnSeven8Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=7man&division=8th"
					
					// Set fallback values for Tackle
					self.tackleVarsityBIG10Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=varsity"
					self.tackleJVBIG10Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=jv"
					self.tackleLightweightBIG10Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=lightweight"
					self.tackleMiddleweightBIG10Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=middleweight"
					self.tackleMiddleweightPACLink = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=middleweight"
					self.tackleFeatherweightBIG10Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=feather"
					self.tackleFeatherweightPACLink = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=featherweight"
					self.tackleBantamBIG10Link = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=big10&division=bantam"
					self.tackleBantamPACLink = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=bantam"
					self.tackleFlightweightPACLink = "https://www.tcyfl.net/TabbedGameSchedulesNEW.php?league=pac10&division=flyweight"
				}
			}
		}
	}
}
