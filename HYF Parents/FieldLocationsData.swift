//
//  FieldLocationsData.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/18/25.
//

import Foundation
import SwiftUI
import Combine

// Model for Football Fields
struct Field: Identifiable, Codable {
	var id: Int
	var name: String
	var address: String
	var is_home_field: Bool
	var notes: String?
}

// Service to fetch fields from Supabase
class FieldService: ObservableObject {
	@Published var fields: [Field] = []
	@Published var isLoading: Bool = true  // Start with loading true
	
	init() {
		print("FieldService initialized")
		fields = FieldLocationsData.fields
		isLoading = false
	}
	
	func fetchFields() {
		print("FieldService: Fetching fields")
		isLoading = true
		
		// Simulate network request with a short delay
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			self.fields = FieldLocationsData.fields
			self.isLoading = false
			print("FieldService: Loaded \(self.fields.count) fields")
		}
	}
	
	// Supabase integration will be added in a future release
	/*
	 // Replace with your actual Supabase URL and API key
	 let client = SupabaseClient(
	 supabaseURL: URL(string: "https://dnnkzeghqckuqinlamps.supabase.co")!,
	 supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRubmt6ZWdocWNrdXFpbmxhbXBzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ1Nzk4NTcsImV4cCI6MjA3MDE1NTg1N30.upNLACkKXkwZ4nfubPpBEI0YiTWxUCbQ-0rW--pAbrE")
	 var request = URLRequest(url: supabaseURL)
	 request.httpMethod = "GET"
	 request.addValue("your-api-key", forHTTPHeaderField: "apikey")
	 request.addValue("Bearer your-api-key", forHTTPHeaderField: "Authorization")
	 
	 URLSession.shared.dataTaskPublisher(for: request)
	 .map(\.data)
	 .decode(type: [Field].self, decoder: JSONDecoder())
	 .receive(on: DispatchQueue.main)
	 .sink(receiveCompletion: { completion in
	 self.isLoading = false
	 if case .failure(let error) = completion {
	 self.error = error.localizedDescription
	 }
	 }, receiveValue: { fields in
	 self.fields = fields
	 })
	 .store(in: &cancellables)
	 */
	
	
	// Static field data for fallback
	struct FieldLocationsData {
		static let fields: [Field] = [
			Field(id: 1, name: "Ameche Field", address: "8560 26th Avenue Kenosha, WI 53143", is_home_field: false, notes: nil),
			Field(id: 2, name: "Antioch High School", address: "1133 Main Street  Antioch, IL 60002", is_home_field: false, notes: nil),
			Field(id: 3, name: "Aurora Christian Schools", address: "2255 Sullivan Rd. Aurora, IL 60506", is_home_field: false, notes: nil),
			Field(id: 4, name: "Barrington Beese Park", address: "50 Rotary Dr. Barrington, IL 60010", is_home_field: false, notes: nil),
			Field(id: 5, name: "Barrington High School", address: "616 W Main St. Barrington, IL 60010", is_home_field: false, notes: "Field is on west side along Hart Rd."),
			Field(id: 6, name: "Barrington HS Auxiliary", address: "616 W Main St. Barrington, IL 60010", is_home_field: false, notes: nil),
			Field(id: 7, name: "Behm Field", address: "22222 W Peterson Rd. Grayslake, IL 60030", is_home_field: false, notes: nil),
			Field(id: 8, name: "Butler Lake Park", address: "810 W Lake Street Libertyville, IL 60048", is_home_field: false, notes: nil),
			Field(id: 9, name: "Carmel High School", address: "1 Carmel Pkwy. Mundelein, IL 60060", is_home_field: false, notes: nil),
			Field(id: 10, name: "Carthage College", address: "2001 Alford Park Drive Kenosha, WI 53140", is_home_field: false, notes: nil),
			Field(id: 11, name: "Cary Junior High", address: "2109 Crystal Lake Road Cary, IL 60013", is_home_field: false, notes: nil),
			Field(id: 12, name: "Community Athletic Fields", address: "1375 N Arlington Heights Rd Itasca, IL 60143", is_home_field: false, notes: nil),
			Field(id: 13, name: "Conant High School", address: "700 E Cougar Trail Hoffman Estates, IL 60169", is_home_field: false, notes: nil),
			Field(id: 14, name: "Concorde Banquets", address: "20922 N. Rand Rd Kildeer, IL 60047", is_home_field: false, notes: nil),
			Field(id: 15, name: "Deerfield High School", address: "1959 Waukegan Rd Deerfield, IL 60015", is_home_field: false, notes: nil),
			Field(id: 16, name: "Deerpath Park", address: "400 Hastings Road Lake Forest, IL 60045", is_home_field: false, notes: nil),
			Field(id: 17, name: "DePaul College Prep", address: "3633 N Rockwell St Chicago, IL 60618", is_home_field: false, notes: nil),
			Field(id: 18, name: "East Aurora High School", address: "500 Tomcat Ln Aurora, IL 60505", is_home_field: false, notes: nil),
			Field(id: 19, name: "Elmwood Park High School", address: "8201 Fullerton Ave Chicago, IL 60707", is_home_field: false, notes: nil),
			Field(id: 20, name: "Emmerich East Field", address: "151 E Raupe Buffalo Grove, IL 60089", is_home_field: false, notes: nil),
			Field(id: 21, name: "Emricson Park", address: "900 W South St Woodstock, IL 60098", is_home_field: false, notes: nil),
			Field(id: 22, name: "Galway Field", address: "2208 Three Oaks Rd Cary, IL 60013", is_home_field: false, notes: "Parking in the Cary High School lot and walk through to field to the Northwest of the High School"),
			Field(id: 23, name: "Glenbrook South HS", address: "4000 W Lake Ave Glenview, IL 60025", is_home_field: false, notes: nil),
			Field(id: 24, name: "Grant Field Of Dreams", address: "26725 W Molidor Rd Ingleside, IL 60041", is_home_field: false, notes: "Park in Lots not on shoulders,Sheriff will ticket"),
			Field(id: 25, name: "Grant High School", address: "285 East Grand Avenue Fox Lake, IL 60020", is_home_field: false, notes: nil),
			Field(id: 26, name: "Grayslake Aquatic Center", address: "250 Library Lane Grayslake, IL 60030", is_home_field: false, notes: nil),
			Field(id: 27, name: "Grayslake Central High School", address: "400 N. Lake Street Grayslake, IL 60030", is_home_field: false, notes: nil),
			Field(id: 28, name: "Grayslake North High School", address: "1925 North Rt 83 Grayslake, IL 60030", is_home_field: false, notes: nil),
			Field(id: 29, name: "Hadley Middle School", address: "1601 Esker Dr Sugar Grove, IL 60554", is_home_field: false, notes: nil),
			Field(id: 30, name: "Heineman Middle School", address: "727 Dr John Burkey Dr Algonquin, IL 60102", is_home_field: true, notes: nil),
			Field(id: 31, name: "Homer T Osdle Field", address: "700 Main St Wauconda, IL 60084", is_home_field: false, notes: nil),
			Field(id: 32, name: "Horlick Athletic Field", address: "1648 N Memorial Dr Racine, WI 53404", is_home_field: false, notes: nil),
			Field(id: 33, name: "Huntley High School", address: "13719 Harmony Rd Huntley, IL 60142", is_home_field: true, notes: "Primary home field"),
			Field(id: 34, name: "Hutcheson Field at Northwestern", address: "2235 Campus Dr Evanston, IL 60208", is_home_field: false, notes: nil),
			Field(id: 35, name: "Indian Hill Elementary School", address: "1920 N. Lotus Dr Round Lake Heights, IL 60073", is_home_field: false, notes: nil),
			Field(id: 36, name: "Jacobs High School", address: "2601 Bunker Hill Algonquin, IL 60102", is_home_field: false, notes: "HHarry D. Jacobs High School Home of the Golden Eagles 2601 Bunker Hill Algonquin IL 60102"),
			Field(id: 37, name: "Jr Zedler Field @Racine Complex", address: "Bethesda Rd & 23rd St Racine, WI 53404", is_home_field: false, notes: nil),
			Field(id: 38, name: "Knox Park", address: "Route 22 and Telser Road Lake Zurich, IL 60047", is_home_field: false, notes: nil),
			Field(id: 39, name: "Lake Forest High School", address: "300 S. Waukegan Rd Lake Forest, IL 60045", is_home_field: false, notes: nil),
			Field(id: 40, name: "Lake Villa Township Park", address: "37974 N. Fairfield Road Lake Villa, IL 60046", is_home_field: false, notes: "Parking is on West side of Fairfield and Game field is on the East side of Fairfield Rd."),
			Field(id: 41, name: "Lake Zurich High School", address: "300 Church Street Lake Zurich, IL 60047", is_home_field: false, notes: nil),
			Field(id: 42, name: "Lakes HS Polley Field", address: "1747 O'plaine Lake Rd Gurnee, IL 60030", is_home_field: false, notes: "Across the street from Lakes High School"),
			Field(id: 43, name: "Lane Tech College Prep High School", address: "2501 W Addison St Chicago, IL 60618", is_home_field: false, notes: nil),
			Field(id: 44, name: "Lazier Field", address: "2285 Church St Evanston, IL 60201", is_home_field: false, notes: nil),
			Field(id: 45, name: "Libertyville High School", address: "708 W Park Ave Libertyville, IL 60048", is_home_field: false, notes: nil),
			Field(id: 46, name: "Lippold Park", address: "851 IL-176 Crystal Lake, IL 60014", is_home_field: false, notes: nil),
			Field(id: 47, name: "Loyola Academy", address: "1100 Laramie Ln Wilmette, IL 60091", is_home_field: false, notes: nil),
			Field(id: 48, name: "Maine East High School", address: "2601 Dempster St Park Ridge, IL 60068", is_home_field: false, notes: nil),
			Field(id: 49, name: "Maine South High School", address: "1111 S Dee Rd Park Ridge, IL 60068", is_home_field: false, notes: nil),
			Field(id: 50, name: "Maine West High School", address: "1755 S Wolf Rd Des Plaines, IL 60018", is_home_field: false, notes: nil),
			Field(id: 51, name: "Maranatha Field", address: "2950 N Lakeshore Dr Chicago, IL", is_home_field: false, notes: nil),
			Field(id: 52, name: "Marlowe Middle School", address: "9625 Haligus Rd Lake in the Hills, IL 60156", is_home_field: true, notes: nil),
			Field(id: 53, name: "Marmion Academy", address: "1000 Butterfield rd Aurora, IL 60502", is_home_field: false, notes: nil),
			Field(id: 54, name: "McHenry High School", address: "5712 Kane Ave McHenry, IL 60050", is_home_field: false, notes: nil),
			Field(id: 55, name: "McHenry Township Park", address: "3703 N Richmond Rd McHenry, IL 60050", is_home_field: false, notes: "Located on the Northwest corner of Johnsburg Rd and Rte 31. The field is located down the road behind the Moose Lodge"),
			Field(id: 56, name: "Melas Park", address: "1500 Central Rd Mt. Prospect, IL 60056", is_home_field: false, notes: nil),
			Field(id: 57, name: "Morton West High School", address: "2400 S Home Berwyn, IL 60402", is_home_field: false, notes: nil),
			Field(id: 58, name: "Mundelein High School", address: "1350 W Hawley St Mundelein, IL 60060", is_home_field: false, notes: nil),
			Field(id: 59, name: "New Trier High School", address: "7 Happ Rd. Glenview, IL 60062", is_home_field: false, notes: nil),
			Field(id: 60, name: "Niles West High School", address: "5701 Oakton St Skokie, IL 60077", is_home_field: false, notes: nil),
			Field(id: 61, name: "North Chicago High School", address: "1850 Lewis Ave North Chicago, IL 60064", is_home_field: false, notes: "Park across Lewis Ave next to Police Dept"),
			Field(id: 62, name: "Olympic Park", address: "1675 E Old Schaumburg Rd Schaumburg, IL 60194", is_home_field: false, notes: "Field 9"),
			Field(id: 63, name: "Panther Field", address: "901571 Burlington Rd Hampshire, IL 60140", is_home_field: false, notes: nil),
			Field(id: 64, name: "Park Panther Field", address: "1901 12th Street Racine, WI 53403", is_home_field: false, notes: nil),
			Field(id: 65, name: "Prairie Ridge High School", address: "6000 Dvorak Dr Crystal Lake, IL 60012", is_home_field: false, notes: nil),
			Field(id: 66, name: "Prospect High School", address: "801 W Kensington Rd Mt Prospect, IL 60056", is_home_field: false, notes: nil),
			Field(id: 67, name: "Riverside Brookfield HS", address: "160 Ridgewood Rd Riverside, IL 60546", is_home_field: false, notes: nil),
			Field(id: 68, name: "Rolling Meadows High School", address: "2901 W Central Rd Rolling Meadows, IL 60008", is_home_field: false, notes: nil),
			Field(id: 69, name: "Round Lake Harts Hill", address: "751 W. Hart Rd Round Lake, IL 60073", is_home_field: false, notes: nil),
			Field(id: 70, name: "Round Lake High School", address: "800 High School Dr Round Lake, IL 60073", is_home_field: false, notes: nil),
			Field(id: 71, name: "Schaumburg High School", address: "1100 W Schaumburg Rd Schaumburg, IL 60194", is_home_field: false, notes: nil),
			Field(id: 72, name: "Sheridan Lutheran High School", address: "9026 12th Street Kenosha, WI 53144", is_home_field: false, notes: nil),
			Field(id: 73, name: "Skokie Playfields", address: "540 Hibbard Rd Winnetka, IL 60093", is_home_field: false, notes: nil),
			Field(id: 74, name: "Sperry Park", address: "800 Michigan Ave South Elgin, IL 60177", is_home_field: false, notes: nil),
			Field(id: 75, name: "St. Ignatius College Prep", address: "1076 Roosevelt Rd Chicago, IL 60608", is_home_field: false, notes: nil),
			Field(id: 76, name: "Stevenson High School Auxiliary Turf Fields", address: "1 Stevenson Dr Lincolnshire, IL 60069", is_home_field: false, notes: "Auxiliary Turf Fields are behind the school near the stadium. Parking in Lot D, which is Small Extension Lot nearest to fields."),
			Field(id: 77, name: "Stevenson High School Stadium", address: "1 Stevenson Dr Lincolnshire, IL 60069", is_home_field: false, notes: "Stadium is located behind the School Stadium Parking is located in Lot E"),
			Field(id: 78, name: "Sunset Park West", address: "5200 Haligus Rd Lake in the Hills, IL", is_home_field: false, notes: nil),
			Field(id: 79, name: "Taft High School", address: "6530 W Bryn Mawr Ave Chicago, IL 60631", is_home_field: false, notes: nil),
			Field(id: 80, name: "Thompson Middle School", address: "705 W Main St St Charles, IL 60174", is_home_field: false, notes: nil),
			Field(id: 81, name: "Tim Osmond Sports Complex", address: "38 Depot St Antioch, IL 60002", is_home_field: false, notes: nil),
			Field(id: 82, name: "Vernon Hills High School", address: "100 Cougar Way Vernon Hills, IL 60061", is_home_field: false, notes: "FRust-Oleum Field"),
			Field(id: 83, name: "Veterans Park", address: "2500 Holmes Way Schaumburg, IL 60194", is_home_field: false, notes: nil),
			Field(id: 84, name: "Warren High School", address: "500 N. OPlaine Rd Gurnee, IL 60031", is_home_field: false, notes: "Field is located on Southwest side of school."),
			Field(id: 85, name: "Wauconda High School", address: "555 N Main Street Wauconda, IL 60084", is_home_field: false, notes: nil),
			Field(id: 86, name: "Weiskopf Sports Park", address: "3391 W Beach Rd Waukegan, IL 60087", is_home_field: false, notes: nil),
			Field(id: 87, name: "West Field", address: "100 N Lewis Ave Waukegan, IL 60085", is_home_field: false, notes: nil),
			Field(id: 88, name: "West Aurora High School", address: "1201 W New York St Aurora, IL 60506", is_home_field: false, notes: nil),
			Field(id: 89, name: "Wildwood Park", address: "6950 N Hiawatha Ave Chicago, IL 60646", is_home_field: false, notes: "Field access is behind Wildwood Middle School."),
			Field(id: 90, name: "William Lutz Stadium", address: "2300 Shermer Rd Northbrook, IL 60062", is_home_field: false, notes: nil),
			Field(id: 91, name: "Willowbrook High School", address: "1250 S Ardmore Ave Villa Park, IL 60181", is_home_field: false, notes: nil),
			Field(id: 92, name: "Wilson Field", address: "4600 N Lake Shore Drive Chicago, IL", is_home_field: false, notes: nil),
			Field(id: 93, name: "Wolters Field", address: "1080 W Park Ave Highland Park, IL 60035", is_home_field: false, notes: nil),
			Field(id: 94, name: "Woodstock High School", address: "501 W South St Woodstock, IL 60098", is_home_field: false, notes: nil),
			Field(id: 95, name: "Woodstock North High School", address: "3000 Raffel Rd Woodstock, IL 60098", is_home_field: false, notes: nil),
			Field(id: 96, name: "Zion Benton High School", address: "3901 West 21st Street Zion, IL 60099", is_home_field: false, notes: nil)
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
}
