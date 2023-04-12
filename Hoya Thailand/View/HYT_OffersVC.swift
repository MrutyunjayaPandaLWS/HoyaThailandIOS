//
//  HYT_OffersVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import SDWebImage
import LanguageManager_iOS
import UIKit

class HYT_OffersVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, OffersDelegate {
    func didTappedViewBtn(item: HYT_OffersTVCell) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_OffersDetailsVC") as? HYT_OffersDetailsVC
        vc?.offersDetails = item.offersData
        navigationController?.pushViewController(vc!, animated: true)
    }
    
  
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var offersTableView: UITableView!
    @IBOutlet weak var offersTitleLbl: UILabel!
    var VM = HYT_OffersVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        offersTableView.delegate = self
        offersTableView.dataSource = self
        emptyMessage.isHidden = true
        OffersApi()
        localization()
    }
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func OffersApi(){
        let parameter : [String : Any] = [
            "ActionType": 99,
            "ActorId": userId,
            "PromotionUserType": "HOYA"
        ]
        self.VM.dashbaordOffers(parameter: parameter)
    }

    
    
//    MARK: - OFFERS TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VM.offersListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_OffersTVCell", for: indexPath) as! HYT_OffersTVCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.offersData = self.VM.offersListArray[indexPath.row]
        cell.offersName.text = self.VM.offersListArray[indexPath.row].promotionName ?? "-"
        let validDate = self.VM.offersListArray[indexPath.row].validTo?.split(separator: " ")
        cell.validDate.text = "\(validDate?[0] ?? "-")"
        if self.VM.offersListArray[indexPath.row].proImage?.count != 0{
            cell.offersImage.sd_setImage(with: URL(string: PROMO_IMG1 + (self.VM.offersListArray[indexPath.row].proImage?.dropFirst(3) ?? "")), placeholderImage: UIImage(named: "ic_default_img (1)"))
        }else{
            cell.offersImage.image = UIImage(named: "ic_default_img (1)")
        }
        
        cell.discountLbl.text = self.VM.offersListArray[indexPath.row].proShortDesc ?? "-"
        return cell
    }
    
    func localization(){
        offersTitleLbl.text = "Offers".localiz()
        
    }
}
