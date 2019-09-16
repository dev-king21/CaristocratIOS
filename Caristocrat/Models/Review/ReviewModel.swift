/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ReviewModel : Codable {
	let id : Int?
	let average_rating : CGFloat?
	let review_message : String?
	let user_details : ReviewUserDetailModel?
	let details : [ReviewRatingModel]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case average_rating = "average_rating"
		case review_message = "review_message"
		case user_details = "user_details"
		case details = "details"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		average_rating = try values.decodeIfPresent(CGFloat.self, forKey: .average_rating)
		review_message = try values.decodeIfPresent(String.self, forKey: .review_message)
		user_details = try values.decodeIfPresent(ReviewUserDetailModel.self, forKey: .user_details)
		details = try values.decodeIfPresent([ReviewRatingModel].self, forKey: .details)
	}

}
