//
//  FieldLocationsData.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/18/25.
//

import Foundation

// Model for Football Fields
struct Field: Identifiable, Codable {
	var id: String
	var name: String
	var address: String
	var is_home_field: Bool
	
	init(id: String, name: String, address: String, is_home_field: Bool = false) {
		self.id = id
		self.name = name
		self.address = address
		self.is_home_field = is_home_field
	}
}

// Static field data for fallback
struct FieldLocationsData {
	static let fields: [Field] = [
		// Home Fields
		Field(id: "1", name: "Huntley High School", address: "13719 Harmony Rd, Huntley, IL 60142", is_home_field: true),
		Field(id: "2", name: "Marlowe Middle School", address: "9625 Haligus Rd, Lake in the Hills, IL 60156", is_home_field: true),
		Field(id: "3", name: "Heineman Middle School", address: "725 Academic Dr, Algonquin, IL 60102", is_home_field: true),
		// Other Fields
		Field(id: "4", name: "Arlington Heights", address: "705 E Oakton St, Arlington Heights, IL 60004"),
		Field(id: "5", name: "Barrington Youth Football", address: "616 W Main St, Barrington, IL 60010"),
		Field(id: "6", name: "Bartlett Raiders", address: "700 S Bartlett Rd, Bartlett, IL 60103"),
		Field(id: "7", name: "Bloomingdale Bears", address: "181 S Bloomingdale Rd, Bloomingdale, IL 60108"),
		Field(id: "8", name: "Buffalo Grove", address: "951 McHenry Rd, Buffalo Grove, IL 60089"),
		Field(id: "9", name: "Cary Jr. Trojans", address: "2400 Three Oaks Rd, Cary, IL 60013"),
		Field(id: "10", name: "Chicago Bulls", address: "1901 W Madison St, Chicago, IL 60612"),
		Field(id: "11", name: "Crystal Lake Raiders", address: "431 N Walkup Ave, Crystal Lake, IL 60014"),
		Field(id: "12", name: "Dundee Township", address: "500 N Randall Rd, West Dundee, IL 60118"),
		Field(id: "13", name: "Elgin", address: "1080 McLean Blvd, Elgin, IL 60123"),
		Field(id: "14", name: "Fox Valley", address: "1000 Wellington Dr, Elgin, IL 60124"),
		Field(id: "15", name: "Grant Youth Football", address: "285 E Grand Ave, Fox Lake, IL 60020"),
		Field(id: "16", name: "Grayslake Colts", address: "240 Commerce Dr, Grayslake, IL 60030"),
		Field(id: "17", name: "Gurnee Vikings", address: "4575 Old Grand Ave, Gurnee, IL 60031"),
		Field(id: "18", name: "Hampshire Wildcats", address: "560 State St, Hampshire, IL 60140"),
		Field(id: "19", name: "Harvard Jr. Hornets", address: "1200 Airport Rd, Harvard, IL 60033"),
		Field(id: "20", name: "Hononegah", address: "307 Salem St, Rockton, IL 61072"),
		Field(id: "21", name: "Johnsburg Jr. Skyhawks", address: "2002 W Ringwood Rd, Johnsburg, IL 60051"),
		Field(id: "22", name: "Kaneland Knights", address: "47W326 Keslinger Rd, Maple Park, IL 60151"),
		Field(id: "23", name: "Lake Forest Scouts", address: "300 S Waukegan Rd, Lake Forest, IL 60045"),
		Field(id: "24", name: "Lake Villa", address: "37850 N Fairfield Rd, Lake Villa, IL 60046"),
		Field(id: "25", name: "Lake Zurich Bears", address: "400 S Old Rand Rd, Lake Zurich, IL 60047"),
		Field(id: "26", name: "Libertyville", address: "1600 W Park Ave, Libertyville, IL 60048"),
		Field(id: "27", name: "Marengo Indians", address: "110 Franks Rd, Marengo, IL 60152"),
		Field(id: "28", name: "McHenry Jr. Warriors", address: "4716 W Crystal Lake Rd, McHenry, IL 60050"),
		Field(id: "29", name: "Mooseheart", address: "240 James J Davis Dr, Mooseheart, IL 60539"),
		Field(id: "30", name: "Mundelein Mustangs", address: "1350 W Hawley St, Mundelein, IL 60060"),
		Field(id: "31", name: "Naperville Patriots", address: "703 S Washington St, Naperville, IL 60540"),
		Field(id: "32", name: "NW DuPage", address: "7N365 Itasca Rd, Itasca, IL 60143"),
		Field(id: "33", name: "PAL Schaumburg", address: "1000 W Schaumburg Rd, Schaumburg, IL 60194"),
		Field(id: "34", name: "Palatine Panthers", address: "1100 N Smith St, Palatine, IL 60067"),
		Field(id: "35", name: "Prospect Heights", address: "110 W Camp McDonald Rd, Prospect Heights, IL 60070"),
		Field(id: "36", name: "Richmond Rockets", address: "10716 Main St, Richmond, IL 60071"),
		Field(id: "37", name: "Rockford Renegades", address: "7135 Argus Dr, Rockford, IL 61107"),
		Field(id: "38", name: "Round Lake", address: "800 High School Dr, Round Lake, IL 60073"),
		Field(id: "39", name: "Schaumburg Vikings", address: "1000 W Schaumburg Rd, Schaumburg, IL 60194"),
		Field(id: "40", name: "South Elgin Storm", address: "760 E Main St, South Elgin, IL 60177"),
		Field(id: "41", name: "St. Charles Saints", address: "1635 S 7th Ave, St. Charles, IL 60174"),
		Field(id: "42", name: "St. Francis/Wheaton", address: "600 W Roosevelt Rd, Wheaton, IL 60187"),
		Field(id: "43", name: "St. Viator Lions", address: "1213 E Oakton St, Arlington Heights, IL 60004"),
		Field(id: "44", name: "Vernon Hills", address: "300 Hawthorn Pkwy, Vernon Hills, IL 60061"),
		Field(id: "45", name: "Wauconda", address: "555 N Main St, Wauconda, IL 60084"),
		Field(id: "46", name: "Waukegan", address: "1011 Washington St, Waukegan, IL 60085"),
		Field(id: "47", name: "Waycinden Cowboys", address: "1700 Robin Ln, Mt Prospect, IL 60056"),
		Field(id: "48", name: "Woodstock", address: "527 W South St, Woodstock, IL 60098"),
		Field(id: "49", name: "Algonquin Argonauts", address: "1220 Longwood Dr, Algonquin, IL 60102"),
		Field(id: "50", name: "Antioch Vikings", address: "1133 Main St, Antioch, IL 60002"),
		Field(id: "51", name: "Arlington Heights Cowboys", address: "310 E Maude Ave, Arlington Heights, IL 60004"),
		Field(id: "52", name: "Crystal Lake Bulldogs", address: "1100 Alexandra Blvd, Crystal Lake, IL 60014"),
		Field(id: "53", name: "Des Plaines Warriors", address: "1401 E Oakton St, Des Plaines, IL 60016"),
		Field(id: "54", name: "Downers Grove Panthers", address: "4400 Main St, Downers Grove, IL 60515"),
		Field(id: "55", name: "Elgin Bears", address: "600 S Mclean Blvd, Elgin, IL 60123"),
		Field(id: "56", name: "Elmhurst Eagles", address: "775 S York St, Elmhurst, IL 60126"),
		Field(id: "57", name: "Fox Lake Falcons", address: "71 Nippersink Blvd, Fox Lake, IL 60020"),
		Field(id: "58", name: "Freeport Jr. Pretzels", address: "1819 S Yellow Creek Rd, Freeport, IL 61032"),
		Field(id: "59", name: "Geneva Vikings", address: "416 McKinley Ave, Geneva, IL 60134"),
		Field(id: "60", name: "Glenview Titans", address: "1401 Greenwood Rd, Glenview, IL 60026"),
		Field(id: "61", name: "Highland Park Falcons", address: "433 Vine Ave, Highland Park, IL 60035"),
		Field(id: "62", name: "Hoffman Estates Redhawks", address: "1100 W Higgins Rd, Hoffman Estates, IL 60169"),
		Field(id: "63", name: "Island Lake Ravens", address: "3720 Greenleaf Ave, Island Lake, IL 60042"),
		Field(id: "64", name: "Kenosha Comets", address: "5400 First Ave, Kenosha, WI 53140"),
		Field(id: "65", name: "Lindenhurst Broncos", address: "2400 E Grand Ave, Lindenhurst, IL 60046"),
		Field(id: "66", name: "Mt. Prospect Cowboys", address: "799 W Central Rd, Mount Prospect, IL 60056"),
		Field(id: "67", name: "Northbrook Spartans", address: "1225 Western Ave, Northbrook, IL 60062"),
		Field(id: "68", name: "Oswego Panthers", address: "4150 IL-71, Oswego, IL 60543"),
		Field(id: "69", name: "Plainfield Wildcats", address: "15211 S Howard St, Plainfield, IL 60544"),
		Field(id: "70", name: "River Grove Trojans", address: "2650 Thatcher Ave, River Grove, IL 60171"),
		Field(id: "71", name: "Roselle Renegades", address: "304 E Pine Ave, Roselle, IL 60172"),
		Field(id: "72", name: "Spring Grove Badgers", address: "8101 Blivin St, Spring Grove, IL 60081"),
		Field(id: "73", name: "Streamwood Seminoles", address: "550 S Park Blvd, Streamwood, IL 60107"),
		Field(id: "74", name: "Sycamore Spartans", address: "427 S California St, Sycamore, IL 60178"),
		Field(id: "75", name: "Walworth Big Foot Chiefs", address: "401 Devils Ln, Walworth, WI 53184"),
		Field(id: "76", name: "Warren Panthers", address: "34090 Almond Rd, Gurnee, IL 60031"),
		Field(id: "77", name: "West Chicago", address: "326 Joliet St, West Chicago, IL 60185"),
		Field(id: "78", name: "Wheeling Wildcats", address: "900 S Elmhurst Rd, Wheeling, IL 60090"),
		Field(id: "79", name: "Willowbrook Burros", address: "1250 S Ardmore Ave, Villa Park, IL 60181"),
		Field(id: "80", name: "Wilmette Eagles", address: "2031 Old Glenview Rd, Wilmette, IL 60091"),
		Field(id: "81", name: "Zion-Benton Zee-Bees", address: "3901 W 21st St, Zion, IL 60099"),
		Field(id: "82", name: "Aurora Superstars", address: "750 S Lincoln Ave, Aurora, IL 60505"),
		Field(id: "83", name: "Belvidere Blue Thunder", address: "1500 East Ave, Belvidere, IL 61008"),
		Field(id: "84", name: "Carol Stream Panthers", address: "301 Lies Rd, Carol Stream, IL 60188"),
		Field(id: "85", name: "DeKalb Barbs", address: "501 W Dresser Rd, DeKalb, IL 60115"),
		Field(id: "86", name: "Harlem Huskies", address: "735 Windsor Rd, Loves Park, IL 61111"),
		Field(id: "87", name: "Lombard Falcons", address: "150 W Madison St, Lombard, IL 60148"),
		Field(id: "88", name: "Marengo Junior Indians", address: "835 S State St, Marengo, IL 60152"),
		Field(id: "89", name: "Morris Warriors", address: "1000 Union St, Morris, IL 60450"),
		Field(id: "90", name: "North Chicago Hornets", address: "2000 Lewis Ave, North Chicago, IL 60064"),
		Field(id: "91", name: "Oak Park Huskies", address: "201 N Scoville Ave, Oak Park, IL 60302"),
		Field(id: "92", name: "Roscoe Rush", address: "10631 Main St, Roscoe, IL 61073"),
		Field(id: "93", name: "Waukegan Bulldogs", address: "2325 Brookside Ave, Waukegan, IL 60085"),
		Field(id: "94", name: "Wheaton Rams", address: "900 S Gary Ave, Wheaton, IL 60187"),
		Field(id: "95", name: "Winnebago Indians", address: "300 E McNair Rd, Winnebago, IL 61088"),
		Field(id: "96", name: "Yorkville Foxes", address: "201 W Countryside Pkwy, Yorkville, IL 60560")
	]
	
	// JSON string version for JavaScript use
	static let fieldsJSON: String = """
	[
		{"id":"1","name":"Huntley High School","address":"13719 Harmony Rd, Huntley, IL 60142","is_home_field":true},
		{"id":"2","name":"Marlowe Middle School","address":"9625 Haligus Rd, Lake in the Hills, IL 60156","is_home_field":true},
		{"id":"3","name":"Heineman Middle School","address":"725 Academic Dr, Algonquin, IL 60102","is_home_field":true},
		{"id":"4","name":"Arlington Heights","address":"705 E Oakton St, Arlington Heights, IL 60004","is_home_field":false},
		{"id":"5","name":"Barrington Youth Football","address":"616 W Main St, Barrington, IL 60010","is_home_field":false},
		{"id":"6","name":"Bartlett Raiders","address":"700 S Bartlett Rd, Bartlett, IL 60103","is_home_field":false},
		{"id":"7","name":"Bloomingdale Bears","address":"181 S Bloomingdale Rd, Bloomingdale, IL 60108","is_home_field":false},
		{"id":"8","name":"Buffalo Grove","address":"951 McHenry Rd, Buffalo Grove, IL 60089","is_home_field":false},
		{"id":"9","name":"Cary Jr. Trojans","address":"2400 Three Oaks Rd, Cary, IL 60013","is_home_field":false},
		{"id":"10","name":"Chicago Bulls","address":"1901 W Madison St, Chicago, IL 60612","is_home_field":false},
		{"id":"11","name":"Crystal Lake Raiders","address":"431 N Walkup Ave, Crystal Lake, IL 60014","is_home_field":false},
		{"id":"12","name":"Dundee Township","address":"500 N Randall Rd, West Dundee, IL 60118","is_home_field":false},
		{"id":"13","name":"Elgin","address":"1080 McLean Blvd, Elgin, IL 60123","is_home_field":false},
		{"id":"14","name":"Fox Valley","address":"1000 Wellington Dr, Elgin, IL 60124","is_home_field":false},
		{"id":"15","name":"Grant Youth Football","address":"285 E Grand Ave, Fox Lake, IL 60020","is_home_field":false},
		{"id":"16","name":"Grayslake Colts","address":"240 Commerce Dr, Grayslake, IL 60030","is_home_field":false},
		{"id":"17","name":"Gurnee Vikings","address":"4575 Old Grand Ave, Gurnee, IL 60031","is_home_field":false},
		{"id":"18","name":"Hampshire Wildcats","address":"560 State St, Hampshire, IL 60140","is_home_field":false},
		{"id":"19","name":"Harvard Jr. Hornets","address":"1200 Airport Rd, Harvard, IL 60033","is_home_field":false},
		{"id":"20","name":"Hononegah","address":"307 Salem St, Rockton, IL 61072","is_home_field":false},
		{"id":"21","name":"Johnsburg Jr. Skyhawks","address":"2002 W Ringwood Rd, Johnsburg, IL 60051","is_home_field":false},
		{"id":"22","name":"Kaneland Knights","address":"47W326 Keslinger Rd, Maple Park, IL 60151","is_home_field":false},
		{"id":"23","name":"Lake Forest Scouts","address":"300 S Waukegan Rd, Lake Forest, IL 60045","is_home_field":false},
		{"id":"24","name":"Lake Villa","address":"37850 N Fairfield Rd, Lake Villa, IL 60046","is_home_field":false},
		{"id":"25","name":"Lake Zurich Bears","address":"400 S Old Rand Rd, Lake Zurich, IL 60047","is_home_field":false},
		{"id":"26","name":"Libertyville","address":"1600 W Park Ave, Libertyville, IL 60048","is_home_field":false},
		{"id":"27","name":"Marengo Indians","address":"110 Franks Rd, Marengo, IL 60152","is_home_field":false},
		{"id":"28","name":"McHenry Jr. Warriors","address":"4716 W Crystal Lake Rd, McHenry, IL 60050","is_home_field":false},
		{"id":"29","name":"Mooseheart","address":"240 James J Davis Dr, Mooseheart, IL 60539","is_home_field":false},
		{"id":"30","name":"Mundelein Mustangs","address":"1350 W Hawley St, Mundelein, IL 60060","is_home_field":false},
		{"id":"31","name":"Naperville Patriots","address":"703 S Washington St, Naperville, IL 60540","is_home_field":false},
		{"id":"32","name":"NW DuPage","address":"7N365 Itasca Rd, Itasca, IL 60143","is_home_field":false},
		{"id":"33","name":"PAL Schaumburg","address":"1000 W Schaumburg Rd, Schaumburg, IL 60194","is_home_field":false},
		{"id":"34","name":"Palatine Panthers","address":"1100 N Smith St, Palatine, IL 60067","is_home_field":false},
		{"id":"35","name":"Prospect Heights","address":"110 W Camp McDonald Rd, Prospect Heights, IL 60070","is_home_field":false},
		{"id":"36","name":"Richmond Rockets","address":"10716 Main St, Richmond, IL 60071","is_home_field":false},
		{"id":"37","name":"Rockford Renegades","address":"7135 Argus Dr, Rockford, IL 61107","is_home_field":false},
		{"id":"38","name":"Round Lake","address":"800 High School Dr, Round Lake, IL 60073","is_home_field":false},
		{"id":"39","name":"Schaumburg Vikings","address":"1000 W Schaumburg Rd, Schaumburg, IL 60194","is_home_field":false},
		{"id":"40","name":"South Elgin Storm","address":"760 E Main St, South Elgin, IL 60177","is_home_field":false},
		{"id":"41","name":"St. Charles Saints","address":"1635 S 7th Ave, St. Charles, IL 60174","is_home_field":false},
		{"id":"42","name":"St. Francis/Wheaton","address":"600 W Roosevelt Rd, Wheaton, IL 60187","is_home_field":false},
		{"id":"43","name":"St. Viator Lions","address":"1213 E Oakton St, Arlington Heights, IL 60004","is_home_field":false},
		{"id":"44","name":"Vernon Hills","address":"300 Hawthorn Pkwy, Vernon Hills, IL 60061","is_home_field":false},
		{"id":"45","name":"Wauconda","address":"555 N Main St, Wauconda, IL 60084","is_home_field":false},
		{"id":"46","name":"Waukegan","address":"1011 Washington St, Waukegan, IL 60085","is_home_field":false},
		{"id":"47","name":"Waycinden Cowboys","address":"1700 Robin Ln, Mt Prospect, IL 60056","is_home_field":false},
		{"id":"48","name":"Woodstock","address":"527 W South St, Woodstock, IL 60098","is_home_field":false},
		{"id":"49","name":"Algonquin Argonauts","address":"1220 Longwood Dr, Algonquin, IL 60102","is_home_field":false},
		{"id":"50","name":"Antioch Vikings","address":"1133 Main St, Antioch, IL 60002","is_home_field":false},
		{"id":"51","name":"Arlington Heights Cowboys","address":"310 E Maude Ave, Arlington Heights, IL 60004","is_home_field":false},
		{"id":"52","name":"Crystal Lake Bulldogs","address":"1100 Alexandra Blvd, Crystal Lake, IL 60014","is_home_field":false},
		{"id":"53","name":"Des Plaines Warriors","address":"1401 E Oakton St, Des Plaines, IL 60016","is_home_field":false},
		{"id":"54","name":"Downers Grove Panthers","address":"4400 Main St, Downers Grove, IL 60515","is_home_field":false},
		{"id":"55","name":"Elgin Bears","address":"600 S Mclean Blvd, Elgin, IL 60123","is_home_field":false},
		{"id":"56","name":"Elmhurst Eagles","address":"775 S York St, Elmhurst, IL 60126","is_home_field":false},
		{"id":"57","name":"Fox Lake Falcons","address":"71 Nippersink Blvd, Fox Lake, IL 60020","is_home_field":false},
		{"id":"58","name":"Freeport Jr. Pretzels","address":"1819 S Yellow Creek Rd, Freeport, IL 61032","is_home_field":false},
		{"id":"59","name":"Geneva Vikings","address":"416 McKinley Ave, Geneva, IL 60134","is_home_field":false},
		{"id":"60","name":"Glenview Titans","address":"1401 Greenwood Rd, Glenview, IL 60026","is_home_field":false},
		{"id":"61","name":"Highland Park Falcons","address":"433 Vine Ave, Highland Park, IL 60035","is_home_field":false},
		{"id":"62","name":"Hoffman Estates Redhawks","address":"1100 W Higgins Rd, Hoffman Estates, IL 60169","is_home_field":false},
		{"id":"63","name":"Island Lake Ravens","address":"3720 Greenleaf Ave, Island Lake, IL 60042","is_home_field":false},
		{"id":"64","name":"Kenosha Comets","address":"5400 First Ave, Kenosha, WI 53140","is_home_field":false},
		{"id":"65","name":"Lindenhurst Broncos","address":"2400 E Grand Ave, Lindenhurst, IL 60046","is_home_field":false},
		{"id":"66","name":"Mt. Prospect Cowboys","address":"799 W Central Rd, Mount Prospect, IL 60056","is_home_field":false},
		{"id":"67","name":"Northbrook Spartans","address":"1225 Western Ave, Northbrook, IL 60062","is_home_field":false},
		{"id":"68","name":"Oswego Panthers","address":"4150 IL-71, Oswego, IL 60543","is_home_field":false},
		{"id":"69","name":"Plainfield Wildcats","address":"15211 S Howard St, Plainfield, IL 60544","is_home_field":false},
		{"id":"70","name":"River Grove Trojans","address":"2650 Thatcher Ave, River Grove, IL 60171","is_home_field":false},
		{"id":"71","name":"Roselle Renegades","address":"304 E Pine Ave, Roselle, IL 60172","is_home_field":false},
		{"id":"72","name":"Spring Grove Badgers","address":"8101 Blivin St, Spring Grove, IL 60081","is_home_field":false},
		{"id":"73","name":"Streamwood Seminoles","address":"550 S Park Blvd, Streamwood, IL 60107","is_home_field":false},
		{"id":"74","name":"Sycamore Spartans","address":"427 S California St, Sycamore, IL 60178","is_home_field":false},
		{"id":"75","name":"Walworth Big Foot Chiefs","address":"401 Devils Ln, Walworth, WI 53184","is_home_field":false},
		{"id":"76","name":"Warren Panthers","address":"34090 Almond Rd, Gurnee, IL 60031","is_home_field":false},
		{"id":"77","name":"West Chicago","address":"326 Joliet St, West Chicago, IL 60185","is_home_field":false},
		{"id":"78","name":"Wheeling Wildcats","address":"900 S Elmhurst Rd, Wheeling, IL 60090","is_home_field":false},
		{"id":"79","name":"Willowbrook Burros","address":"1250 S Ardmore Ave, Villa Park, IL 60181","is_home_field":false},
		{"id":"80","name":"Wilmette Eagles","address":"2031 Old Glenview Rd, Wilmette, IL 60091","is_home_field":false},
		{"id":"81","name":"Zion-Benton Zee-Bees","address":"3901 W 21st St, Zion, IL 60099","is_home_field":false},
		{"id":"82","name":"Aurora Superstars","address":"750 S Lincoln Ave, Aurora, IL 60505","is_home_field":false},
		{"id":"83","name":"Belvidere Blue Thunder","address":"1500 East Ave, Belvidere, IL 61008","is_home_field":false},
		{"id":"84","name":"Carol Stream Panthers","address":"301 Lies Rd, Carol Stream, IL 60188","is_home_field":false},
		{"id":"85","name":"DeKalb Barbs","address":"501 W Dresser Rd, DeKalb, IL 60115","is_home_field":false},
		{"id":"86","name":"Harlem Huskies","address":"735 Windsor Rd, Loves Park, IL 61111","is_home_field":false},
		{"id":"87","name":"Lombard Falcons","address":"150 W Madison St, Lombard, IL 60148","is_home_field":false},
		{"id":"88","name":"Marengo Junior Indians","address":"835 S State St, Marengo, IL 60152","is_home_field":false},
		{"id":"89","name":"Morris Warriors","address":"1000 Union St, Morris, IL 60450","is_home_field":false},
		{"id":"90","name":"North Chicago Hornets","address":"2000 Lewis Ave, North Chicago, IL 60064","is_home_field":false},
		{"id":"91","name":"Oak Park Huskies","address":"201 N Scoville Ave, Oak Park, IL 60302","is_home_field":false},
		{"id":"92","name":"Roscoe Rush","address":"10631 Main St, Roscoe, IL 61073","is_home_field":false},
		{"id":"93","name":"Waukegan Bulldogs","address":"2325 Brookside Ave, Waukegan, IL 60085","is_home_field":false},
		{"id":"94","name":"Wheaton Rams","address":"900 S Gary Ave, Wheaton, IL 60187","is_home_field":false},
		{"id":"95","name":"Winnebago Indians","address":"300 E McNair Rd, Winnebago, IL 61088","is_home_field":false},
		{"id":"96","name":"Yorkville Foxes","address":"201 W Countryside Pkwy, Yorkville, IL 60560","is_home_field":false}
	]
	"""
}

// Service to fetch fields from Supabase (optional enhancement)
class FieldService {
	func fetchFields(completion: @escaping ([Field]?, Error?) -> Void) {
		// For now, return the hardcoded fields
		completion(FieldLocationsData.fields, nil)
		
		// In the future, you could implement actual API calls to Supabase here
		// Example:
		/*
		 let supabaseURL = URL(string: "https://your-project-id.supabase.co/rest/v1/fields")!
		 var request = URLRequest(url: supabaseURL)
		 request.httpMethod = "GET"
		 request.addValue("apikey-here", forHTTPHeaderField: "apikey")
		 request.addValue("Bearer apikey-here", forHTTPHeaderField: "Authorization")
		 
		 URLSession.shared.dataTask(with: request) { data, response, error in
		 if let error = error {
		 completion(nil, error)
		 return
		 }
		 
		 guard let data = data else {
		 completion(nil, NSError(domain: "FieldService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
		 return
		 }
		 
		 do {
		 let fields = try JSONDecoder().decode([Field].self, from: data)
		 completion(fields, nil)
		 } catch {
		 print("Error decoding fields: \(error)")
		 // Fall back to static data
		 completion(FieldLocationsData.fields, nil)
		 }
		 }.resume()
		 */
	}
}
