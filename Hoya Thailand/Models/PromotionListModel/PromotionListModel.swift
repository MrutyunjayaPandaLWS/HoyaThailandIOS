

import Foundation
struct PromotionListModel : Codable {
	let ltyPrgBaseDetails : [LtyPrgBaseDetails]?
	let ltyProgDetails : String?
	let ltyProgFeeRewardDetails : String?
	let ltyProgFilterDetails : String?
	let lstLtyProductRuleDetails : [String]?
	let lstLtyTieredAwardFilterDetails : String?
	let lstLtyProgLocationDetails : String?
	let lstLtyProgSubFilterBehaviour : String?
	let lstLtyProgTxnChannelDetails : String?
	let lstLtyProgPaymentModeDetails : String?
	let lstLtyProgFestivalDetails : String?
	let lstLtyProgSpecificDaysDetails : String?
	let lstLtyPointsExpiryFilter : String?
	let activeType : String?
	let programContribution : Double?
	let lstLtyProductRuleTieredDetails : String?
	let lstProductBulkRule : String?
	let lstLtyAwardBasisUOM : String?
	let loyaltyProgramMemberMapping : String?
	let lstProgramBehaviour : String?
	let ltyProductHierachyRuleList : String?
	let walletList : String?
	let walletHierarchyList : String?
	let ltyWalletProductHierachyConfgRuleList : String?
	let walletHierarchyAwardList : String?
	let ltyWalletProductHierachyAwardRuleList : String?
	let returnValue : Int?
	let returnMessage : String?
	let totalRecords : Int?

	enum CodingKeys: String, CodingKey {

		case ltyPrgBaseDetails = "ltyPrgBaseDetails"
		case ltyProgDetails = "ltyProgDetails"
		case ltyProgFeeRewardDetails = "ltyProgFeeRewardDetails"
		case ltyProgFilterDetails = "ltyProgFilterDetails"
		case lstLtyProductRuleDetails = "lstLtyProductRuleDetails"
		case lstLtyTieredAwardFilterDetails = "lstLtyTieredAwardFilterDetails"
		case lstLtyProgLocationDetails = "lstLtyProgLocationDetails"
		case lstLtyProgSubFilterBehaviour = "lstLtyProgSubFilterBehaviour"
		case lstLtyProgTxnChannelDetails = "lstLtyProgTxnChannelDetails"
		case lstLtyProgPaymentModeDetails = "lstLtyProgPaymentModeDetails"
		case lstLtyProgFestivalDetails = "lstLtyProgFestivalDetails"
		case lstLtyProgSpecificDaysDetails = "lstLtyProgSpecificDaysDetails"
		case lstLtyPointsExpiryFilter = "lstLtyPointsExpiryFilter"
		case activeType = "activeType"
		case programContribution = "programContribution"
		case lstLtyProductRuleTieredDetails = "lstLtyProductRuleTieredDetails"
		case lstProductBulkRule = "lstProductBulkRule"
		case lstLtyAwardBasisUOM = "lstLtyAwardBasisUOM"
		case loyaltyProgramMemberMapping = "loyaltyProgramMemberMapping"
		case lstProgramBehaviour = "lstProgramBehaviour"
		case ltyProductHierachyRuleList = "ltyProductHierachyRuleList"
		case walletList = "walletList"
		case walletHierarchyList = "walletHierarchyList"
		case ltyWalletProductHierachyConfgRuleList = "ltyWalletProductHierachyConfgRuleList"
		case walletHierarchyAwardList = "walletHierarchyAwardList"
		case ltyWalletProductHierachyAwardRuleList = "ltyWalletProductHierachyAwardRuleList"
		case returnValue = "returnValue"
		case returnMessage = "returnMessage"
		case totalRecords = "totalRecords"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		ltyPrgBaseDetails = try values.decodeIfPresent([LtyPrgBaseDetails].self, forKey: .ltyPrgBaseDetails)
		ltyProgDetails = try values.decodeIfPresent(String.self, forKey: .ltyProgDetails)
		ltyProgFeeRewardDetails = try values.decodeIfPresent(String.self, forKey: .ltyProgFeeRewardDetails)
		ltyProgFilterDetails = try values.decodeIfPresent(String.self, forKey: .ltyProgFilterDetails)
		lstLtyProductRuleDetails = try values.decodeIfPresent([String].self, forKey: .lstLtyProductRuleDetails)
		lstLtyTieredAwardFilterDetails = try values.decodeIfPresent(String.self, forKey: .lstLtyTieredAwardFilterDetails)
		lstLtyProgLocationDetails = try values.decodeIfPresent(String.self, forKey: .lstLtyProgLocationDetails)
		lstLtyProgSubFilterBehaviour = try values.decodeIfPresent(String.self, forKey: .lstLtyProgSubFilterBehaviour)
		lstLtyProgTxnChannelDetails = try values.decodeIfPresent(String.self, forKey: .lstLtyProgTxnChannelDetails)
		lstLtyProgPaymentModeDetails = try values.decodeIfPresent(String.self, forKey: .lstLtyProgPaymentModeDetails)
		lstLtyProgFestivalDetails = try values.decodeIfPresent(String.self, forKey: .lstLtyProgFestivalDetails)
		lstLtyProgSpecificDaysDetails = try values.decodeIfPresent(String.self, forKey: .lstLtyProgSpecificDaysDetails)
		lstLtyPointsExpiryFilter = try values.decodeIfPresent(String.self, forKey: .lstLtyPointsExpiryFilter)
		activeType = try values.decodeIfPresent(String.self, forKey: .activeType)
		programContribution = try values.decodeIfPresent(Double.self, forKey: .programContribution)
		lstLtyProductRuleTieredDetails = try values.decodeIfPresent(String.self, forKey: .lstLtyProductRuleTieredDetails)
		lstProductBulkRule = try values.decodeIfPresent(String.self, forKey: .lstProductBulkRule)
		lstLtyAwardBasisUOM = try values.decodeIfPresent(String.self, forKey: .lstLtyAwardBasisUOM)
		loyaltyProgramMemberMapping = try values.decodeIfPresent(String.self, forKey: .loyaltyProgramMemberMapping)
		lstProgramBehaviour = try values.decodeIfPresent(String.self, forKey: .lstProgramBehaviour)
		ltyProductHierachyRuleList = try values.decodeIfPresent(String.self, forKey: .ltyProductHierachyRuleList)
		walletList = try values.decodeIfPresent(String.self, forKey: .walletList)
		walletHierarchyList = try values.decodeIfPresent(String.self, forKey: .walletHierarchyList)
		ltyWalletProductHierachyConfgRuleList = try values.decodeIfPresent(String.self, forKey: .ltyWalletProductHierachyConfgRuleList)
		walletHierarchyAwardList = try values.decodeIfPresent(String.self, forKey: .walletHierarchyAwardList)
		ltyWalletProductHierachyAwardRuleList = try values.decodeIfPresent(String.self, forKey: .ltyWalletProductHierachyAwardRuleList)
		returnValue = try values.decodeIfPresent(Int.self, forKey: .returnValue)
		returnMessage = try values.decodeIfPresent(String.self, forKey: .returnMessage)
		totalRecords = try values.decodeIfPresent(Int.self, forKey: .totalRecords)
	}

}
