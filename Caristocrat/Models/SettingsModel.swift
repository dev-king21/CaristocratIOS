/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct SettingsModel : Codable {
	let id : Int?
	let default_language : String?
	let email : String?
	let logo : String?
	let phone : String?
	let latitude : String?
	let longitude : String?
	let depreciation_trend : Int?
	let limit_for_cars : String?
	let limit_for_featured_cars : String?
	let playstore : String?
	let appstore : String?
	let social_links : String?
	let app_version : Int?
	let force_update : String?
	let created_at : String?
	let updated_at : String?
	let deleted_at : String?
	let title : String?
	let address : String?
	let about : String?
	let personal_shopper : String?
	let ask_for_consultancy : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case default_language = "default_language"
		case email = "email"
		case logo = "logo"
		case phone = "phone"
		case latitude = "latitude"
		case longitude = "longitude"
		case depreciation_trend = "depreciation_trend"
		case limit_for_cars = "limit_for_cars"
		case limit_for_featured_cars = "limit_for_featured_cars"
		case playstore = "playstore"
		case appstore = "appstore"
		case social_links = "social_links"
		case app_version = "app_version"
		case force_update = "force_update"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case deleted_at = "deleted_at"
		case title = "title"
		case address = "address"
		case about = "about"
		case personal_shopper = "personal_shopper"
		case ask_for_consultancy = "ask_for_consultancy"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		default_language = try values.decodeIfPresent(String.self, forKey: .default_language)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		logo = try values.decodeIfPresent(String.self, forKey: .logo)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
		longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
		depreciation_trend = try values.decodeIfPresent(Int.self, forKey: .depreciation_trend)
		limit_for_cars = try values.decodeIfPresent(String.self, forKey: .limit_for_cars)
		limit_for_featured_cars = try values.decodeIfPresent(String.self, forKey: .limit_for_featured_cars)
		playstore = try values.decodeIfPresent(String.self, forKey: .playstore)
		appstore = try values.decodeIfPresent(String.self, forKey: .appstore)
		social_links = try values.decodeIfPresent(String.self, forKey: .social_links)
		app_version = try values.decodeIfPresent(Int.self, forKey: .app_version)
		force_update = try values.decodeIfPresent(String.self, forKey: .force_update)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		deleted_at = try values.decodeIfPresent(String.self, forKey: .deleted_at)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		about = try values.decodeIfPresent(String.self, forKey: .about)
		personal_shopper = try values.decodeIfPresent(String.self, forKey: .personal_shopper)
		ask_for_consultancy = try values.decodeIfPresent(String.self, forKey: .ask_for_consultancy)
	}

}
