/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/



import Foundation
struct Limited_edition_specs_array : Codable {
	let dimensions_Weight : [Specs]?
	let seating_Capacity : [Specs]?
	let drivetrain : [Specs]?
	let engine : [Specs]?
	let performance : [Specs]?
	let transmission  : [Specs ]?
	let brakes : [Specs]?
	let suspension : [Specs]?
	let wheels_Tyres : [Specs]?
	let fuel : [Specs]?
	let emission : [Specs]?
	let warranty_Maintenance : [Specs]?

    public enum CodingKeys: String, CodingKey {

		case dimensions_Weight = "Dimensions_Weight"
		case seating_Capacity = "Seating_Capacity"
		case drivetrain = "DRIVE_TRAIN"
		case engine = "Engine"
		case performance = "Performance"
		case transmission  = "Transmission "
		case brakes = "Brakes"
		case suspension = "Suspension"
		case wheels_Tyres = "Wheels_Tyres"
		case fuel = "Fuel"
		case emission = "Emission"
		case warranty_Maintenance = "Warranty_Maintenance"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        dimensions_Weight = try values.decodeIfPresent([Specs].self, forKey: .dimensions_Weight)
		seating_Capacity = try values.decodeIfPresent([Specs].self, forKey: .seating_Capacity)
		drivetrain = try values.decodeIfPresent([Specs].self, forKey: .drivetrain)
		engine = try values.decodeIfPresent([Specs].self, forKey: .engine)
		performance = try values.decodeIfPresent([Specs].self, forKey: .performance)
		transmission  = try values.decodeIfPresent([Specs].self, forKey: .transmission)
		brakes = try values.decodeIfPresent([Specs].self, forKey: .brakes)
		suspension = try values.decodeIfPresent([Specs].self, forKey: .suspension)
		wheels_Tyres = try values.decodeIfPresent([Specs].self, forKey: .wheels_Tyres)
		fuel = try values.decodeIfPresent([Specs].self, forKey: .fuel)
		emission = try values.decodeIfPresent([Specs].self, forKey: .emission)
		warranty_Maintenance = try values.decodeIfPresent([Specs].self, forKey: .warranty_Maintenance)
	}

}
