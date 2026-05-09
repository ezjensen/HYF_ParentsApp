//
//  HomeFieldSchedulesView.swift
//  HYF Parents
//
//  Created by Eric Jensen on 5/9/26.
//

import SwiftUI
import Supabase

class HomeFieldScheduleStore: ObservableObject {
	@Published var schedules: [HomeFieldSchedule] = []
	@Published var isLoading = false
	@Published var loadError = false

	func fetchSchedules() {
		isLoading = true
		loadError = false

		Task { @MainActor in
			do {
				let result: [HomeFieldSchedule] = try await supabase
					.from("HomeField_Schedules")
					.select()
					.execute()
					.value

				self.schedules = result
				self.isLoading = false
			} catch {
				print("Error fetching home field schedules: \(error)")
				self.loadError = true
				self.isLoading = false
			}
		}
	}
}

struct HomeFieldSchedulesView: View {
	@Environment(\.dismiss) private var dismiss
	@StateObject private var store = HomeFieldScheduleStore()

	@State private var showFilters = false
	@State private var filterWeek = "All"
	@State private var filterScheduleLevel = "All"
	@State private var filterProgramLevel = "All"
	@State private var filterAway = "All"
	@State private var filterHome = "All"
	@State private var filterField = "All"

	@State private var sortField: SortField = .week
	@State private var sortAscending = true
	@State private var expandedWeeks: Set<String> = []
	@State private var showPrintOptions = false
	@State private var printScheduleLevel = true
	@State private var printProgramLevel = true
	@State private var printDate = true
	@State private var printTime = true
	@State private var printAway = true
	@State private var printHome = true
	@State private var printField = true

	enum SortField: String, CaseIterable {
		case week = "Week"
		case scheduleLevel = "Schedule Level"
		case programLevel = "Program Level"
		case date = "Date"
		case time = "Time"
		case away = "Away"
		case home = "Home"
		case field = "Field"
	}

	private static let programLevelOrder = [
		"Flyweight", "Bantam", "Featherweight", "Middleweight",
		"LW/JV/Varsity", "K-1st", "2-3rd", "3-5th", "6-7th", "6-8th", "8th"
	]

	private static let teamColors: [String: Color] = [
		"black": .black,
		"white": Color(white: 0.85),
		"red": .red,
		"blue": .blue,
		"green": .green,
		"gold": Color(red: 0.85, green: 0.65, blue: 0),
		"orange": .orange,
		"silver": Color(white: 0.75),
		"purple": .purple,
		"pink": .pink,
		"navy": Color(red: 0, green: 0, blue: 0.5),
		"maroon": Color(red: 0.5, green: 0, blue: 0),
		"gray": .gray,
		"grey": .gray,
		"yellow": .yellow,
	]

	private var activeFilterCount: Int {
		[filterWeek, filterScheduleLevel, filterProgramLevel,
		 filterAway, filterHome, filterField]
			.filter { $0 != "All" }.count
	}

	private func weekNumber(_ week: String) -> Int {
		let digits = week.filter { $0.isNumber }
		return Int(digits) ?? 0
	}

	private func programLevelSortIndex(_ level: String) -> Int {
		if let index = Self.programLevelOrder.firstIndex(of: level) {
			return index
		}
		return Self.programLevelOrder.count
	}

	private func teamColor(_ name: String) -> Color? {
		let words = name.lowercased().split(separator: " ")
		guard let lastWord = words.last else { return nil }
		return Self.teamColors[String(lastWord)]
	}

	private func formatTime(_ time: String) -> String {
		let parts = time.prefix(8).split(separator: ":")
		guard parts.count >= 2, let hour = Int(parts[0]) else { return time }
		let minute = parts[1]
		let period = hour >= 12 ? "PM" : "AM"
		let displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour)
		return "\(displayHour):\(minute) \(period)"
	}

	private func expandedBinding(for week: String) -> Binding<Bool> {
		Binding(
			get: { expandedWeeks.contains(week) },
			set: { isExpanded in
				if isExpanded {
					expandedWeeks.insert(week)
				} else {
					expandedWeeks.remove(week)
				}
			}
		)
	}

	private var uniqueWeeks: [String] {
		let values = Set(store.schedules.map(\.week))
		return ["All"] + values.sorted { weekNumber($0) < weekNumber($1) }
	}

	private var uniqueScheduleLevels: [String] {
		["All"] + Set(store.schedules.map(\.scheduleLevel)).sorted()
	}

	private var uniqueProgramLevels: [String] {
		let values = Set(store.schedules.map(\.programLevel))
		let ordered = Self.programLevelOrder.filter { values.contains($0) }
		let remaining = values.filter { !Self.programLevelOrder.contains($0) }.sorted()
		return ["All"] + ordered + remaining
	}

	private var uniqueAway: [String] {
		["All"] + Set(store.schedules.map(\.away)).sorted()
	}

	private var uniqueHome: [String] {
		["All"] + Set(store.schedules.map(\.home)).sorted()
	}

	private var uniqueFields: [String] {
		["All"] + Set(store.schedules.map(\.field)).sorted()
	}

	private var filteredSchedules: [HomeFieldSchedule] {
		var result = store.schedules

		if filterWeek != "All" { result = result.filter { $0.week == filterWeek } }
		if filterScheduleLevel != "All" { result = result.filter { $0.scheduleLevel == filterScheduleLevel } }
		if filterProgramLevel != "All" { result = result.filter { $0.programLevel == filterProgramLevel } }
		if filterAway != "All" { result = result.filter { $0.away == filterAway } }
		if filterHome != "All" { result = result.filter { $0.home == filterHome } }
		if filterField != "All" { result = result.filter { $0.field == filterField } }

		result.sort { a, b in
			let comparison: Bool
			switch sortField {
			case .week: comparison = weekNumber(a.week) < weekNumber(b.week)
			case .scheduleLevel: comparison = a.scheduleLevel < b.scheduleLevel
			case .programLevel: comparison = programLevelSortIndex(a.programLevel) < programLevelSortIndex(b.programLevel)
			case .date: comparison = a.date < b.date
			case .time: comparison = a.time < b.time
			case .away: comparison = a.away < b.away
			case .home: comparison = a.home < b.home
			case .field: comparison = a.field < b.field
			}
			return sortAscending ? comparison : !comparison
		}

		return result
	}

	private var groupedWeeks: [String] {
		let weeks = Set(filteredSchedules.map(\.week))
		return weeks.sorted { weekNumber($0) < weekNumber($1) }
	}

	var body: some View {
		NavigationStack {
			Group {
				if store.isLoading {
					ProgressView("Loading schedules...")
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				} else if store.loadError {
					ContentUnavailableView {
						Label("Unable to Load", systemImage: "exclamationmark.triangle")
					} description: {
						Text("Could not load home field schedules.")
					} actions: {
						Button("Try Again") { store.fetchSchedules() }
					}
				} else if store.schedules.isEmpty {
					ContentUnavailableView(
						"No Schedules",
						systemImage: "calendar.badge.exclamationmark",
						description: Text("No home field schedules are available.")
					)
				} else {
					List {
						if showFilters {
							Section {
								Picker("Week", selection: $filterWeek) {
									ForEach(uniqueWeeks, id: \.self) { Text($0) }
								}
								Picker("Schedule Level", selection: $filterScheduleLevel) {
									ForEach(uniqueScheduleLevels, id: \.self) { Text($0) }
								}
								Picker("Program Level", selection: $filterProgramLevel) {
									ForEach(uniqueProgramLevels, id: \.self) { Text($0) }
								}
								Picker("Away", selection: $filterAway) {
									ForEach(uniqueAway, id: \.self) { Text($0) }
								}
								Picker("Home", selection: $filterHome) {
									ForEach(uniqueHome, id: \.self) { Text($0) }
								}
								Picker("Field", selection: $filterField) {
									ForEach(uniqueFields, id: \.self) { Text($0) }
								}

								if activeFilterCount > 0 {
									Button("Clear All Filters") { clearFilters() }
										.foregroundColor(.red)
								}
							} header: {
								Text("Filters")
							}
						}

						ForEach(groupedWeeks, id: \.self) { week in
							let weekGames = filteredSchedules.filter { $0.week == week }
							DisclosureGroup(isExpanded: expandedBinding(for: week)) {
								ForEach(weekGames) { schedule in
									scheduleRow(schedule)
								}
							} label: {
								Text("\(week) \u{2014} \(weekGames.count) game\(weekGames.count == 1 ? "" : "s")")
									.font(.subheadline)
									.fontWeight(.semibold)
							}
						}
					}
				}
			}
			.navigationTitle("Home Field Schedules")
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("Done") { dismiss() }
				}
				ToolbarItemGroup(placement: .topBarTrailing) {
					Button {
						withAnimation { showFilters.toggle() }
					} label: {
						Image(systemName: activeFilterCount > 0
							  ? "line.3.horizontal.decrease.circle.fill"
							  : "line.3.horizontal.decrease.circle")
					}

					Menu {
						ForEach(SortField.allCases, id: \.self) { field in
							Button {
								if sortField == field {
									sortAscending.toggle()
								} else {
									sortField = field
									sortAscending = true
								}
							} label: {
								HStack {
									Text(field.rawValue)
									if sortField == field {
										Image(systemName: sortAscending ? "chevron.up" : "chevron.down")
									}
								}
							}
						}
					} label: {
						Image(systemName: "arrow.up.arrow.down")
					}

					Button { showPrintOptions = true } label: {
						Image(systemName: "printer")
					}
					.disabled(filteredSchedules.isEmpty)
				}
			}
			.task {
				store.fetchSchedules()
			}
			.onChange(of: store.isLoading) { _, isLoading in
				if !isLoading && !store.loadError {
					autoExpandUpcomingWeek()
				}
			}
			.sheet(isPresented: $showPrintOptions) {
				printOptionsSheet
			}
		}
		.tint(.red)
	}

	private var printOptionsSheet: some View {
		NavigationStack {
			List {
				Section {
					Text("\(filteredSchedules.count) game\(filteredSchedules.count == 1 ? "" : "s") will be printed based on your current filters.")
						.font(.caption)
						.foregroundColor(.secondary)
				}

				Section("Columns to Include") {
					Toggle("Schedule Level", isOn: $printScheduleLevel)
					Toggle("Program Level", isOn: $printProgramLevel)
					Toggle("Date", isOn: $printDate)
					Toggle("Time", isOn: $printTime)
					Toggle("Away", isOn: $printAway)
					Toggle("Home", isOn: $printHome)
					Toggle("Field", isOn: $printField)
				}

				Section {
					Button {
						showPrintOptions = false
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
							printSchedules()
						}
					} label: {
						HStack {
							Spacer()
							Label("Print", systemImage: "printer")
								.fontWeight(.semibold)
							Spacer()
						}
					}
					.disabled(!printScheduleLevel && !printProgramLevel && !printDate && !printTime && !printAway && !printHome && !printField)
				}
			}
			.navigationTitle("Print Options")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Cancel") { showPrintOptions = false }
				}
			}
		}
		.presentationDetents([.medium])
	}

	@ViewBuilder
	private func teamNameView(_ name: String) -> some View {
		HStack(spacing: 4) {
			if let color = teamColor(name) {
				Circle()
					.fill(color)
					.overlay(Circle().stroke(Color.secondary.opacity(0.3), lineWidth: 0.5))
					.frame(width: 10, height: 10)
			}
			Text(name)
		}
	}

	private func scheduleRow(_ schedule: HomeFieldSchedule) -> some View {
		VStack(alignment: .leading, spacing: 6) {
			HStack {
				Text(schedule.date)
					.font(.caption)
					.foregroundColor(.secondary)
				Text(formatTime(schedule.time))
					.font(.caption)
					.foregroundColor(.secondary)
				Spacer()
				Text("\(schedule.scheduleLevel) \u{2022} \(schedule.programLevel)")
					.font(.caption2)
					.foregroundColor(.secondary)
			}

			HStack(spacing: 4) {
				teamNameView(schedule.away)
				Text("vs")
					.foregroundColor(.secondary)
				teamNameView(schedule.home)
			}
			.font(.subheadline)
			.fontWeight(.semibold)

			Label(schedule.field, systemImage: "mappin.and.ellipse")
				.font(.caption)
				.foregroundColor(.secondary)
		}
		.padding(.vertical, 4)
	}

	private func autoExpandUpcomingWeek() {
		let today = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"

		var bestWeek: String?
		var bestDate: Date?

		for schedule in store.schedules {
			if let date = formatter.date(from: schedule.date), date >= today {
				if bestDate == nil || date < bestDate! {
					bestDate = date
					bestWeek = schedule.week
				}
			}
		}

		if let week = bestWeek ?? groupedWeeks.last {
			expandedWeeks.insert(week)
		}
	}

	private func clearFilters() {
		filterWeek = "All"
		filterScheduleLevel = "All"
		filterProgramLevel = "All"
		filterAway = "All"
		filterHome = "All"
		filterField = "All"
	}

	private func printSchedules() {
		let schedules = filteredSchedules
		guard !schedules.isEmpty else { return }

		var headers = ""
		if printScheduleLevel { headers += "<th>Level</th>" }
		if printProgramLevel { headers += "<th>Program</th>" }
		if printDate { headers += "<th>Date</th>" }
		if printTime { headers += "<th>Time</th>" }
		if printAway { headers += "<th>Away</th>" }
		if printHome { headers += "<th>Home</th>" }
		if printField { headers += "<th>Field</th>" }

		var html = """
		<html><head><style>
		body { font-family: -apple-system, Helvetica, sans-serif; font-size: 11px; margin: 20px; }
		h1 { font-size: 18px; margin-bottom: 4px; }
		h2 { font-size: 14px; margin-top: 16px; margin-bottom: 4px; color: #c00; }
		.count { font-size: 12px; color: #666; margin-bottom: 12px; }
		table { width: 100%; border-collapse: collapse; margin-bottom: 12px; }
		th { background: #c00; color: white; padding: 6px 4px; text-align: left; font-size: 10px; }
		td { padding: 4px; border-bottom: 1px solid #ddd; font-size: 10px; }
		tr:nth-child(even) { background: #f9f9f9; }
		</style></head><body>
		<h1>Home Field Schedules</h1>
		<p class="count">\(schedules.count) game\(schedules.count == 1 ? "" : "s")</p>
		"""

		for week in groupedWeeks {
			let weekSchedules = schedules.filter { $0.week == week }
			html += "<h2>\(week)</h2>"
			html += "<table><tr>\(headers)</tr>"
			for s in weekSchedules {
				html += "<tr>"
				if printScheduleLevel { html += "<td>\(s.scheduleLevel)</td>" }
				if printProgramLevel { html += "<td>\(s.programLevel)</td>" }
				if printDate { html += "<td>\(s.date)</td>" }
				if printTime { html += "<td>\(formatTime(s.time))</td>" }
				if printAway { html += "<td>\(s.away)</td>" }
				if printHome { html += "<td>\(s.home)</td>" }
				if printField { html += "<td>\(s.field)</td>" }
				html += "</tr>"
			}
			html += "</table>"
		}

		html += "</body></html>"

		let printController = UIPrintInteractionController.shared
		let printInfo = UIPrintInfo(dictionary: nil)
		printInfo.jobName = "Home Field Schedules"
		printInfo.outputType = .general
		printController.printInfo = printInfo
		printController.printFormatter = UIMarkupTextPrintFormatter(markupText: html)
		printController.present(animated: true)
	}
}
