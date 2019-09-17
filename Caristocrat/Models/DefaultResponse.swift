//
//  NewsModel.swift
 import Foundation
struct DefaultResponse : Codable {
   let id : Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"

    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
    }
    
}

