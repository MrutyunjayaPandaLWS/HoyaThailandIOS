


import Foundation
struct LstPushHistoryJson : Codable {
    let pushHistoryId : Int?
    let modifiedBy : Int?
    let createdDate : String?
    let jCreatedDate : String?
    let createdBy : Int?
    let sourceType : String?
    let isActive : Int?
    let isRead : Int?
    let pushMessage : String?
    let pushId : String?
    let loyaltyId : String?
    let pushType : String?
    let imagesURL : String?
    let title : String?

    enum CodingKeys: String, CodingKey {

        case pushHistoryId = "pushHistoryId"
        case modifiedBy = "modifiedBy"
        case createdDate = "createdDate"
        case jCreatedDate = "jCreatedDate"
        case createdBy = "createdBy"
        case sourceType = "sourceType"
        case isActive = "isActive"
        case isRead = "isRead"
        case pushMessage = "pushMessage"
        case pushId = "pushId"
        case loyaltyId = "loyaltyId"
        case pushType = "pushType"
        case imagesURL = "imagesURL"
        case title = "title"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pushHistoryId = try values.decodeIfPresent(Int.self, forKey: .pushHistoryId)
        modifiedBy = try values.decodeIfPresent(Int.self, forKey: .modifiedBy)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        jCreatedDate = try values.decodeIfPresent(String.self, forKey: .jCreatedDate)
        createdBy = try values.decodeIfPresent(Int.self, forKey: .createdBy)
        sourceType = try values.decodeIfPresent(String.self, forKey: .sourceType)
        isActive = try values.decodeIfPresent(Int.self, forKey: .isActive)
        isRead = try values.decodeIfPresent(Int.self, forKey: .isRead)
        pushMessage = try values.decodeIfPresent(String.self, forKey: .pushMessage)
        pushId = try values.decodeIfPresent(String.self, forKey: .pushId)
        loyaltyId = try values.decodeIfPresent(String.self, forKey: .loyaltyId)
        pushType = try values.decodeIfPresent(String.self, forKey: .pushType)
        imagesURL = try values.decodeIfPresent(String.self, forKey: .imagesURL)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }

}
