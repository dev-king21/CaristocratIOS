//
//	TutorialData.swift
//
//	Create by   on 9/4/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class TutorialData : Codable {

	let content : String?
	let createdAt : String?
	let id : Int?
	let media : [TutorialMedia]?
	let sort : Int?
	let title : String?
	let type : Int?
	let typeText : String?


	enum CodingKeys: String, CodingKey {
		case content = "content"
		case createdAt = "created_at"
		case id = "id"
		case media = "media"
		case sort = "sort"
		case title = "title"
		case type = "type"
		case typeText = "type_text"
	}
	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		content = try values.decodeIfPresent(String.self, forKey: .content) ?? String()
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? String()
		id = try values.decodeIfPresent(Int.self, forKey: .id) ?? Int()
		media = try values.decodeIfPresent([TutorialMedia].self, forKey: .media) ?? [TutorialMedia]()
		sort = try values.decodeIfPresent(Int.self, forKey: .sort) ?? Int()
		title = try values.decodeIfPresent(String.self, forKey: .title) ?? String()
		type = try values.decodeIfPresent(Int.self, forKey: .type) ?? Int()
		typeText = try values.decodeIfPresent(String.self, forKey: .typeText) ?? String()
	}


}
