/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct UserDetailsModel : Codable {
	let id : Int?
	let first_name : String?
	let last_name : String?
	let phone : String?
    let countryCode : String?
	let address : String?
	let image : String?
	let email_updates : Bool?
	let social_login : Bool?
	let image_url : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case first_name = "first_name"
		case last_name = "last_name"
		case phone = "phone"
		case address = "address"
		case image = "image"
		case email_updates = "email_updates"
		case social_login = "social_login"
		case image_url = "image_url"
        case countryCode = "country_code"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
		last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		email_updates = try values.decodeIfPresent(Bool.self, forKey: .email_updates)
		social_login = try values.decodeIfPresent(Bool.self, forKey: .social_login)
		image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        countryCode = try values.decodeIfPresent(String.self, forKey: .countryCode)
	}

}
