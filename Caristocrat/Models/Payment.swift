//
//  Payment.swift
//  Caristocrat
//
//  Created by Khunshan Ahmad on 05/09/2019.
//  Copyright © 2019 Ingic. All rights reserved.
//

import Foundation

// MARK: - ReportPaymentCheckModel
struct ReportPaymentCheckModel: Codable {
    let userID: Int?
    let toDate: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case toDate = "to_date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        toDate = try values.decodeIfPresent(String.self, forKey: .toDate)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID)
    }
}


// MARK: - SingleReportPayment
struct ReportPaymentModel: Codable {
    let userID, newsID, transactionID, toDate: String?
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case newsID = "news_id"
        case transactionID = "transaction_id"
        case toDate = "to_date"
        case id
    }
}


// MARK: - Comparision Payment Check 
struct ComparisionPaymentCheckModel: Codable {
    let id, userID: Int?
    let transactionID, fromDate, toDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case transactionID = "transaction_id"
        case fromDate = "from_date"
        case toDate = "to_date"
    }
}
