/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct TopBids : Codable {
	let id : Int?
	let amount : String?
	let currency : String?
	let notes : String?
	let type : Int?
	let bid_close_at : Bid_close_at?
	let evaluation_details : [Evaluation_details]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case amount = "amount"
		case currency = "currency"
		case notes = "notes"
		case type = "type"
		case bid_close_at = "bid_close_at"
		case evaluation_details = "evaluation_details"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		amount = try values.decodeIfPresent(String.self, forKey: .amount)
		currency = try values.decodeIfPresent(String.self, forKey: .currency)
		notes = try values.decodeIfPresent(String.self, forKey: .notes)
		type = try values.decodeIfPresent(Int.self, forKey: .type)
		bid_close_at = try values.decodeIfPresent(Bid_close_at.self, forKey: .bid_close_at)
		evaluation_details = try values.decodeIfPresent([Evaluation_details].self, forKey: .evaluation_details)
	}

}
