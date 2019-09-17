/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct My_car : Codable {
	let id : Int?
	let views_count : Int?
	let favorite_count : Int?
	let like_count : Int?
	let year : Int?
	let chassis : String?
	let kilometer : String?
	let average_mkp : String?
	let amount : Int?
	let name : String?
	let email : String?
	let country_code : String?
	let phone : Int?
	let notes : String?
	let life_cycle : String?
	let status : Int?
	let is_featured : Int?
	let bid_close_at : String?
	let created_at : String?
	let transmission_type_text : String?
	let link : String?
	let status_text : String?
	let owner_type_text : String?
//    let top_bids : [String]?
	let is_liked : Bool?
	let is_viewed : Bool?
	let is_favorite : Bool?
	let limited_edition_specs_array : Limited_edition_specs_array?
	let depreciation_trend_value : [Depreciation_trend_value]?
	let ref_num : String?
	let owner : Owner?
	let car_model : Car_model?
	let car_type : Car_type?
	let media : [Media]?
	let my_car_attributes : [MyCarAttributes]?
	let regional_specs : Regional_specs?
	let car_regions : [Car_regions]?
	let category : Category?
	let engine_type : Engine_type?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case views_count = "views_count"
		case favorite_count = "favorite_count"
		case like_count = "like_count"
		case year = "year"
		case chassis = "chassis"
		case kilometer = "kilometer"
		case average_mkp = "average_mkp"
		case amount = "amount"
		case name = "name"
		case email = "email"
		case country_code = "country_code"
		case phone = "phone"
		case notes = "notes"
		case life_cycle = "life_cycle"
		case status = "status"
		case is_featured = "is_featured"
		case bid_close_at = "bid_close_at"
		case created_at = "created_at"
		case transmission_type_text = "transmission_type_text"
		case link = "link"
		case status_text = "status_text"
		case owner_type_text = "owner_type_text"
//        case top_bids = "top_bids"
		case is_liked = "is_liked"
		case is_viewed = "is_viewed"
		case is_favorite = "is_favorite"
		case limited_edition_specs_array = "limited_edition_specs_array"
		case depreciation_trend_value = "depreciation_trend_value"
		case ref_num = "ref_num"
		case owner = "owner"
		case car_model = "car_model"
		case car_type = "car_type"
		case media = "media"
		case my_car_attributes = "my_car_attributes"
		case regional_specs = "regional_specs"
		case car_regions = "car_regions"
		case category = "category"
		case engine_type = "engine_type"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		views_count = try values.decodeIfPresent(Int.self, forKey: .views_count)
		favorite_count = try values.decodeIfPresent(Int.self, forKey: .favorite_count)
		like_count = try values.decodeIfPresent(Int.self, forKey: .like_count)
		year = try values.decodeIfPresent(Int.self, forKey: .year)
		chassis = try values.decodeIfPresent(String.self, forKey: .chassis)
		kilometer = try values.decodeIfPresent(String.self, forKey: .kilometer)
		average_mkp = try values.decodeIfPresent(String.self, forKey: .average_mkp)
		amount = try values.decodeIfPresent(Int.self, forKey: .amount)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		country_code = try values.decodeIfPresent(String.self, forKey: .country_code)
		phone = try values.decodeIfPresent(Int.self, forKey: .phone)
		notes = try values.decodeIfPresent(String.self, forKey: .notes)
		life_cycle = try values.decodeIfPresent(String.self, forKey: .life_cycle)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		is_featured = try values.decodeIfPresent(Int.self, forKey: .is_featured)
		bid_close_at = try values.decodeIfPresent(String.self, forKey: .bid_close_at)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		transmission_type_text = try values.decodeIfPresent(String.self, forKey: .transmission_type_text)
		link = try values.decodeIfPresent(String.self, forKey: .link)
		status_text = try values.decodeIfPresent(String.self, forKey: .status_text)
		owner_type_text = try values.decodeIfPresent(String.self, forKey: .owner_type_text)
//        top_bids = try values.decodeIfPresent([String].self, forKey: .top_bids)
		is_liked = try values.decodeIfPresent(Bool.self, forKey: .is_liked)
		is_viewed = try values.decodeIfPresent(Bool.self, forKey: .is_viewed)
		is_favorite = try values.decodeIfPresent(Bool.self, forKey: .is_favorite)
		limited_edition_specs_array = try values.decodeIfPresent(Limited_edition_specs_array.self, forKey: .limited_edition_specs_array)
		depreciation_trend_value = try values.decodeIfPresent([Depreciation_trend_value].self, forKey: .depreciation_trend_value)
		ref_num = try values.decodeIfPresent(String.self, forKey: .ref_num)
		owner = try values.decodeIfPresent(Owner.self, forKey: .owner)
		car_model = try values.decodeIfPresent(Car_model.self, forKey: .car_model)
		car_type = try values.decodeIfPresent(Car_type.self, forKey: .car_type)
		media = try values.decodeIfPresent([Media].self, forKey: .media)
		my_car_attributes = try values.decodeIfPresent([MyCarAttributes].self, forKey: .my_car_attributes)
		regional_specs = try values.decodeIfPresent(Regional_specs.self, forKey: .regional_specs)
		car_regions = try values.decodeIfPresent([Car_regions].self, forKey: .car_regions)
		category = try values.decodeIfPresent(Category.self, forKey: .category)
		engine_type = try values.decodeIfPresent(Engine_type.self, forKey: .engine_type)
	}

}
