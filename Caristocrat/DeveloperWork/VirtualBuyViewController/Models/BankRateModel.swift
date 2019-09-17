/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct BankRateModel : Codable {
	let id : Int?
	let title : String?
	let phone_no : String?
	let address : String?
	let rate : Double?
	let type : Int?
	let created_at : String?
	let media : [MediaModel]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case title = "title"
		case phone_no = "phone_no"
		case address = "address"
		case rate = "rate"
		case type = "type"
		case created_at = "created_at"
		case media = "media"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		phone_no = try values.decodeIfPresent(String.self, forKey: .phone_no)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		rate = try values.decodeIfPresent(Double.self, forKey: .rate)
		type = try values.decodeIfPresent(Int.self, forKey: .type)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		media = try values.decodeIfPresent([MediaModel].self, forKey: .media)
	}

}
