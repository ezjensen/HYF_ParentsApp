//
//  HYF_ParentsApp.swift
//  HYF Parents
//
//  Created by Eric Jensen on 6/20/25.
//

import SwiftUI

@main
struct HYFParentsApp: App {
	// Initialize all shared stores at app launch
	@StateObject private var rulesStore = LeagueRulesStore.shared
	@StateObject private var scheduleStore = ScheduleStore.shared
	@StateObject private var fieldService = FieldService.shared
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(rulesStore)
				.environmentObject(scheduleStore)
				.environmentObject(fieldService)
				.onAppear {
					// Call loadFields when the view appears if fields are empty
					if fieldService.fields.isEmpty {
						fieldService.loadFields()
					}
					// Also pre-fetch field locations for the WebView
					getFieldLocations()
				}
		}
	}
}
