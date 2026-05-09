//
//  Models.swift
//  HYF Parents
//
//  Created by Eric Jensen on 8/8/25.
//

import Foundation

struct HomeFieldSchedule: Identifiable, Codable {
	var id = UUID()
	let week: String
	let scheduleLevel: String
	let programLevel: String
	let date: String
	let time: String
	let away: String
	let home: String
	let field: String

	enum CodingKeys: String, CodingKey {
		case week
		case scheduleLevel = "ScheduleLevel"
		case programLevel = "ProgramLevel"
		case date = "Date"
		case time = "Time"
		case away = "Away"
		case home = "Home"
		case field = "Field"
	}
}
