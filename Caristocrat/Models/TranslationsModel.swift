/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Translations : Codable {
	let id : Int?
	let page_id : Int?
	let locale : String?
	let title : String?
	let content : String?
	let status : Bool?
	let created_at : String?
	let updated_at : String?
	let deleted_at : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case page_id = "page_id"
		case locale = "locale"
		case title = "title"
		case content = "content"
		case status = "status"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case deleted_at = "deleted_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		page_id = try values.decodeIfPresent(Int.self, forKey: .page_id)
		locale = try values.decodeIfPresent(String.self, forKey: .locale)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		content = try values.decodeIfPresent(String.self, forKey: .content)
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		deleted_at = try values.decodeIfPresent(String.self, forKey: .deleted_at)
	}

}