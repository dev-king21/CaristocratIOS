//
//  CategoryModel.swift
 import Foundation
struct CategoryModel : Codable {
    let id : Int?
    let user_id : Int?
    var unreadCount: Int?
    let created_at : String?
    let updated_at : String?
    let name : String?
    let desc : String?
    let slug : String?
    let subtitle : String?
    let subCategories: [CategoryModel]?
    let media : [Media]?
    let type : Int?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case user_id = "user_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case name = "name"
        case subCategories = "child_category"
        case media = "media"
        case subtitle = "subtitle"
        case unreadCount = "unread_count"
        case type = "type"
        case slug = "slug"
        case desc = "description"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        unreadCount = try values.decodeIfPresent(Int.self, forKey: .unreadCount)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        subtitle = try values.decodeIfPresent(String.self, forKey: .subtitle)
        subCategories = try values.decodeIfPresent([CategoryModel].self, forKey: .subCategories)
        media = try values.decodeIfPresent([Media].self, forKey: .media)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        desc = try values.decodeIfPresent(String.self, forKey: .desc)
    }
    
}
