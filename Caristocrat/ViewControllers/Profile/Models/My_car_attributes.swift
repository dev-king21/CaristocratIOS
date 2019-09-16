/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct My_car_attributes : Codable {
	let value : String?
	let attr_id : Int?
	let attr_name : String?
	let attr_icon : String?
	let attr_option : String?

	enum CodingKeys: String, CodingKey {

		case value = "value"
		case attr_id = "attr_id"
		case attr_name = "attr_name"
		case attr_icon = "attr_icon"
		case attr_option = "attr_option"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		value = try values.decodeIfPresent(String.self, forKey: .value)
		attr_id = try values.decodeIfPresent(Int.self, forKey: .attr_id)
		attr_name = try values.decodeIfPresent(String.self, forKey: .attr_name)
		attr_icon = try values.decodeIfPresent(String.self, forKey: .attr_icon)
		attr_option = try values.decodeIfPresent(String.self, forKey: .attr_option)
	}

}