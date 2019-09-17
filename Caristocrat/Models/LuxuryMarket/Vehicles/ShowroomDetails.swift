

import Foundation
struct ShowroomDetails : Codable {
	let id : Int?
	let name : String?
	let address : String?
	let phone : String?
	let email : String?
	let about : String?
	let media : [Media]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case address = "address"
		case phone = "phone"
		case email = "email"
		case about = "about"
		case media = "media"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		about = try values.decodeIfPresent(String.self, forKey: .about)
		media = try values.decodeIfPresent([Media].self, forKey: .media)
	}

}
