//
//  BodyStyleModel.swift
 import Foundation

//class BodyStyleModel {
//    var id: Int?
//    var title: String?
//    var detail: String?
//    var selectedImage: String?
//    var unSelectedImage: String?
//
//    init(id: Int, title: String, detail: String,selectedImage: String,unSelectedImage: String) {
//        self.id = id
//        self.title = title
//        self.detail = detail
//        self.selectedImage = selectedImage
//        self.unSelectedImage = unSelectedImage
//    }
//
//    class func getAllStyles() {
//        var styles: [BodyStyleModel] = []
//        styles.append(BodyStyleModel.init(id: 1, title: "Saloon", detail: "4 Doors", selectedImage: "4-doors-in-white", unSelectedImage: "4-doors"))
//        styles.append(BodyStyleModel.init(id: 1, title: "Snart", detail: "2 Doors", selectedImage: "2-doors", unSelectedImage: "2-doors-in-black"))
//        styles.append(BodyStyleModel.init(id: 1, title: "SUV", detail: "", selectedImage: "SUV2", unSelectedImage: "SUV"))
//        styles.append(BodyStyleModel.init(id: 1, title: "Convertable", detail: "", selectedImage: "convertable2", unSelectedImage: "convertable"))
//
//    }
//
//}

import Foundation
struct BodyStyleModel: Codable {
    let id : Int?
    let image : String?
    let selected_icon : String?
    let un_selected_icon : String?
    let name : String?
    let childSegment : [ChildSegment]?
    var isChecked = false
    var group : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case image = "image"
        case selected_icon = "selected_icon"
        case un_selected_icon = "un_selected_icon"
        case name = "name"
        case childSegment = "child_types"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        selected_icon = try values.decodeIfPresent(String.self, forKey: .selected_icon)
        un_selected_icon = try values.decodeIfPresent(String.self, forKey: .un_selected_icon)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        childSegment = try values.decodeIfPresent([ChildSegment].self, forKey: .childSegment)
    }
    
}

struct ChildSegment: Codable {
    let id : Int?
    let image : String?
    let selected_icon : String?
    let un_selected_icon : String?
    let name : String?
    var child_types : [String]?
    var group: String?
    var version: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case image = "image"
        case selected_icon = "selected_icon"
        case un_selected_icon = "un_selected_icon"
        case name = "name"
        case child_types = "child_types"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        selected_icon = try values.decodeIfPresent(String.self, forKey: .selected_icon)
        un_selected_icon = try values.decodeIfPresent(String.self, forKey: .un_selected_icon)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        child_types = try values.decodeIfPresent([String].self, forKey: .child_types)
    }
    
}

struct Group {
    let group: String
    var isChecked: Bool
    
    init(group: String, checked: Bool) {
        self.group = group
        self.isChecked = checked
    }
}

struct GroupData {
    let id: Int
    let group: String
    let version: String
    
    init(id: Int, group: String, version: String) {
        self.id = id
        self.group = group
        self.version = version
    }
}

