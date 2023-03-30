

import Foundation
struct ObjCatalogueFixedPoints : Codable {
	let fixedPoints : Int?
	let productCode : String?

	enum CodingKeys: String, CodingKey {

		case fixedPoints = "fixedPoints"
		case productCode = "productCode"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		fixedPoints = try values.decodeIfPresent(Int.self, forKey: .fixedPoints)
		productCode = try values.decodeIfPresent(String.self, forKey: .productCode)
	}

}
