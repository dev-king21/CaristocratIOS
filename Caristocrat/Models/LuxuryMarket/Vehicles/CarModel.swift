

import Foundation
struct CarModel : Codable {
	let id : Int?
	let name : String?
	let brand : Brand?
    var isSelected: Bool = false
    
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case name = "name"
		case brand = "brand"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		brand = try values.decodeIfPresent(Brand.self, forKey: .brand)
	}
    
    init() {
        id = -1
        name = "All Models"
        brand = nil
        isSelected = false
    }

}
