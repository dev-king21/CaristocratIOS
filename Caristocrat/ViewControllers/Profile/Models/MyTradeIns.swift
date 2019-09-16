/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct MyTradeIns : Codable {
	let id : Int?
	let amount : Int?
	let notes : String?
	let bid_close_at : Bid_close_at?
	let my_car : VehicleBase?
	let trade_against : VehicleBase?
    let dealer_info : DealerInfo?
    let offer_details : [OfferDetails]?
    let is_expired: Bool?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case amount = "amount"
		case notes = "notes"
		case bid_close_at = "bid_close_at"
		case my_car = "my_car"
		case trade_against = "trade_against"
        case dealer_info = "dealer_info"
        case offer_details = "offer_details"
        case is_expired = "is_expired"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		amount = try values.decodeIfPresent(Int.self, forKey: .amount)
		notes = try values.decodeIfPresent(String.self, forKey: .notes)
		bid_close_at = try values.decodeIfPresent(Bid_close_at.self, forKey: .bid_close_at)
		my_car = try values.decodeIfPresent(VehicleBase.self, forKey: .my_car)
		trade_against = try values.decodeIfPresent(VehicleBase.self, forKey: .trade_against)
        dealer_info = try values.decodeIfPresent(DealerInfo.self, forKey: .dealer_info)
        offer_details = try values.decodeIfPresent([OfferDetails].self, forKey: .offer_details)
        is_expired = try values.decodeIfPresent(Bool.self, forKey: .is_expired)
    }

}
