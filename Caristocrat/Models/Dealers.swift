/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Dealers : Codable {
	let id : Int?
	let name : String?
	let email : String?
	let created_at : String?
	let push_notification : Int?
	let cars_count : Int?
	let favorite_count : Int?
	let like_count : Int?
	let view_count : Int?
	var details : Details?
	let showroom_details : Showroom_details?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case email = "email"
		case created_at = "created_at"
		case push_notification = "push_notification"
		case cars_count = "cars_count"
		case favorite_count = "favorite_count"
		case like_count = "like_count"
		case view_count = "view_count"
		case details = "details"
		case showroom_details = "showroom_details"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		push_notification = try values.decodeIfPresent(Int.self, forKey: .push_notification)
		cars_count = try values.decodeIfPresent(Int.self, forKey: .cars_count)
		favorite_count = try values.decodeIfPresent(Int.self, forKey: .favorite_count)
		like_count = try values.decodeIfPresent(Int.self, forKey: .like_count)
		view_count = try values.decodeIfPresent(Int.self, forKey: .view_count)
		details = try values.decodeIfPresent(Details.self, forKey: .details)
		showroom_details = try values.decodeIfPresent(Showroom_details.self, forKey: .showroom_details)
	}

}
