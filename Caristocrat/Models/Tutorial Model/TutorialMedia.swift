//
//	TutorialMedia.swift
//
//	Create by   on 9/4/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class TutorialMedia : Codable {

	let createdAt : String?
	let fileUrl : String?
	let filename : String?
	let id : Int?
	let mediaType : Int?
	let title : String?


	enum CodingKeys: String, CodingKey {
		case createdAt = "created_at"
		case fileUrl = "file_url"
		case filename = "filename"
		case id = "id"
		case mediaType = "media_type"
		case title = "title"
	}
	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? String()
		fileUrl = try values.decodeIfPresent(String.self, forKey: .fileUrl) ?? String()
		filename = try values.decodeIfPresent(String.self, forKey: .filename) ?? String()
		id = try values.decodeIfPresent(Int.self, forKey: .id) ?? Int()
		mediaType = try values.decodeIfPresent(Int.self, forKey: .mediaType) ?? Int()
		title = try values.decodeIfPresent(String.self, forKey: .title) ?? String()
	}


}
