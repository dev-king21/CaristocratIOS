//
//  NewsModel.swift
 import Foundation
struct NewsModel : Codable {

    let id : Int?
    let category_id : Int?
    let user_id : Int?
    var views_count : Int?
    var favorite_count : Int?
    var like_count : Int?
    var comments_count : Int?
    let is_featured : Int?
    let created_at : String?
    let updated_at : String?
    var is_liked : Bool?
    var is_viewed : Bool?
    var is_favorite : Bool?
    let headline : String?
    let description : String?
    let source : String?
    let media : [Media]?
    let source_image_url : String?
    let link : String?
    let link2 : String?
    let related_car : String?


    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case category_id = "category_id"
        case user_id = "user_id"
        case views_count = "views_count"
        case favorite_count = "favorite_count"
        case like_count = "like_count"
        case comments_count = "comments_count"
        case is_featured = "is_featured"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case is_liked = "is_liked"
        case is_viewed = "is_viewed"
        case is_favorite = "is_favorite"
        case headline = "headline"
        case description = "description"
        case source = "source"
        case media = "media"
        case source_image_url = "source_image_url"
        case link = "link"
        case link2 = "link2"
        case related_car = "related_car"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        category_id = try values.decodeIfPresent(Int.self, forKey: .category_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        views_count = try values.decodeIfPresent(Int.self, forKey: .views_count)
        favorite_count = try values.decodeIfPresent(Int.self, forKey: .favorite_count)
        like_count = try values.decodeIfPresent(Int.self, forKey: .like_count)
        comments_count = try values.decodeIfPresent(Int.self, forKey: .comments_count)
        is_featured = try values.decodeIfPresent(Int.self, forKey: .is_featured)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        is_liked = try values.decodeIfPresent(Bool.self, forKey: .is_liked)
        is_viewed = try values.decodeIfPresent(Bool.self, forKey: .is_viewed)
        is_favorite = try values.decodeIfPresent(Bool.self, forKey: .is_favorite)
        headline = try values.decodeIfPresent(String.self, forKey: .headline)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        source = try values.decodeIfPresent(String.self, forKey: .source)
        media = try values.decodeIfPresent([Media].self, forKey: .media)
        source_image_url = try values.decodeIfPresent(String.self, forKey: .source_image_url)
        link = try values.decodeIfPresent(String.self, forKey: .link)
        link2 = try values.decodeIfPresent(String.self, forKey: .link2)
        related_car = try values.decodeIfPresent(String.self, forKey: .related_car)
    }

    
}
