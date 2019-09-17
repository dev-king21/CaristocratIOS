//
//	TutorialBase.swift
//
//	Create by   on 9/4/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class TutorialBase : Codable {

	let data : [TutorialData]?
	let message : String?
	let success : Bool?
	let totalCount : Int?


	enum CodingKeys: String, CodingKey {
		case data = "data"
		case message = "message"
		case success = "success"
		case totalCount = "total_count"
	}
	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		data = try values.decodeIfPresent([TutorialData].self, forKey: .data) ?? [TutorialData]()
		message = try values.decodeIfPresent(String.self, forKey: .message) ?? String()
		success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? Bool()
		totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount) ?? Int()
	}


}
