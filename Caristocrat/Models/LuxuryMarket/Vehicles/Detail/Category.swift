/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Category : Codable {
	let id : Int?
	let slug : String?
	let user_id : Int?
	let type : Int?
	let created_at : String?
	let updated_at : String?
	let clicks_count : Int?
	let name : String?
	let subtitle : String?
	let description : String?
	let media : [Media]?
	let child_category : [String]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case slug = "slug"
		case user_id = "user_id"
		case type = "type"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case clicks_count = "clicks_count"
		case name = "name"
		case subtitle = "subtitle"
		case description = "description"
		case media = "media"
		case child_category = "child_category"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		slug = try values.decodeIfPresent(String.self, forKey: .slug)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		type = try values.decodeIfPresent(Int.self, forKey: .type)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		clicks_count = try values.decodeIfPresent(Int.self, forKey: .clicks_count)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		subtitle = try values.decodeIfPresent(String.self, forKey: .subtitle)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		media = try values.decodeIfPresent([Media].self, forKey: .media)
		child_category = try values.decodeIfPresent([String].self, forKey: .child_category)
	}

}