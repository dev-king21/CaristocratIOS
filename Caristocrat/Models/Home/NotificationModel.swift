/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct NotificationModel : Codable {
    let id : Int?
    let action_type : Int?
    let ref_id : Int?
    let message : String?
    let created_at : String?
    let image_url : String?
    let car_name : String?
    let model_year : Int?
    let chassis : String?
    let type : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case action_type = "action_type"
        case ref_id = "ref_id"
        case message = "message"
        case created_at = "created_at"
        case image_url = "image_url"
        case car_name = "car_name"
        case model_year = "model_year"
        case chassis = "chassis"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        action_type = try values.decodeIfPresent(Int.self, forKey: .action_type)
        ref_id = try values.decodeIfPresent(Int.self, forKey: .ref_id)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        car_name = try values.decodeIfPresent(String.self, forKey: .car_name)
        model_year = try values.decodeIfPresent(Int.self, forKey: .model_year)
        chassis = try values.decodeIfPresent(String.self, forKey: .chassis)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
    }

}
