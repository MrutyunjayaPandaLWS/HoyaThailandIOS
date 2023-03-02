

import Foundation
struct PointExpireModel : Codable {
	let lstAttributesDetails : [eVoucherPointExpModel]?
	let actionType : Int?

	enum CodingKeys: String, CodingKey {

		case lstAttributesDetails = "lstAttributesDetails"
		case actionType = "actionType"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		lstAttributesDetails = try values.decodeIfPresent([eVoucherPointExpModel].self, forKey: .lstAttributesDetails)
		actionType = try values.decodeIfPresent(Int.self, forKey: .actionType)
	}

}
