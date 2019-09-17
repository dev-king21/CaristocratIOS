//
//  AllSubscriptionsModel.swift
//  Caristocrat
//
//  Created by Khunshan Ahmad on 11/09/2019.
//  Copyright © 2019 Ingic. All rights reserved.
//

import Foundation

// MARK: - AllSubscriptionsModel
struct AllSubscriptionsModel: Codable {
    let userID: Int?
    let title, type, fromDate, toDate: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case title, type
        case fromDate = "from_date"
        case toDate = "to_date"
    }
}


/*
// MARK: - AllSubscriptionsModel
struct AllSubscriptionsModel: Codable {
    let allreportpayment, onereportPayment, checkprocompsubs: [Allreportpayment]?
    //let onsiteCourses: [JSONAny]?
}

// MARK: - Allreportpayment
struct Allreportpayment: Codable {
    let id, userID: Int?   
    let transactionID, fromDate, toDate: String?
    let user: [SubscribedUser]?
    let newsID: Int?
    let news: [News]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case transactionID = "transaction_id"
        case fromDate = "from_date"
        case toDate = "to_date"
        case user
        case newsID = "news_id"
        case news
    }
}

// MARK: - News
struct News: Codable {
    let id, categoryID: Int?
    let relatedCar: String?
    //let userID: JSONNull?
    let viewsCount, favoriteCount, likeCount, commentsCount: Int?
    let slug: String?
    let isFeatured: Int?
    let createdAt, updatedAt: String?
    let link: String?
    let link2: String?
    let isLiked, isViewed, isFavorite: Bool?
    let sourceImageURL: String?
    let headline, newsDescription: String?
    //let source: JSONNull?
    let media: [Media]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case relatedCar = "related_car"
//        case userID = "user_id"
        case viewsCount = "views_count"
        case favoriteCount = "favorite_count"
        case likeCount = "like_count"
        case commentsCount = "comments_count"
        case slug
        case isFeatured = "is_featured"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case link, link2
        case isLiked = "is_liked"
        case isViewed = "is_viewed"
        case isFavorite = "is_favorite"
        case sourceImageURL = "source_image_url"
        case headline
        case newsDescription = "description"
//        case source
        case media
    }
}

// MARK: - User
struct SubscribedUser: Codable {
    let id: Int?
    let name, email: String?
    let status: Int?
    let createdAt: String?
    let pushNotification, carsCount, favoriteCount, likeCount: Int?
    let viewCount: Int?
    let details: Details?
    //let showroomDetails: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, status
        case createdAt = "created_at"
        case pushNotification = "push_notification"
        case carsCount = "cars_count"
        case favoriteCount = "favorite_count"
        case likeCount = "like_count"
        case viewCount = "view_count"
        case details
        //case showroomDetails = "showroom_details"
    }
}
*/
