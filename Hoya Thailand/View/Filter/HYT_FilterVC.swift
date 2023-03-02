//
//  HYT_FilterVC.swift
//  Hoya Thailand
//
//  Created by syed on 10/02/23.
//

import UIKit
import Toast_Swift

protocol FilterProtocolDelegate{
    func didTappedFilterBtn(item: HYT_FilterVC)
}

class HYT_FilterVC: UIViewController, DatePickerDelegate, FilterStatusDelegate {
    func didTappedFilterStatus(item: HYT_DropDownVC) {
        statusName = item.statusName
        statusId = item.statusId
        selectPromotionNameLbl.text = statusName
    }
    
    func didTappedDOA(date: String) {
        
    }
    
    func didTappedFromDate(date: String) {
        fromDate = date
        fromDateLbl.text = date
    }
    
    func didTappedToDate(date: String) {
        toDate = date
        toDateLbl.text = date
    }
    
    func didTappedDOB(date: String) {
    }
    
    func didTappedPromotionName(item: HYT_DropDownVC) {
        selectPromotionNameLbl.text = item.promotionName
    }

    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var promotionNameViewHeight: NSLayoutConstraint!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var selectPromotionNameLbl: UILabel!
    @IBOutlet weak var filterLbl: UILabel!
    
    var delegate: FilterProtocolDelegate?
    var promotionNameHeight = 38
    var bottomConstraintsValue = 30
    var fromDate = ""
    var toDate = ""
    var flags = ""
    var statusName = ""
    var statusId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        promotionNameViewHeight.constant = CGFloat(promotionNameHeight)
        bottomConstraints.constant = CGFloat(bottomConstraintsValue)
        
    }
    
    @IBAction func didTappedTodateBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_DatePickerVC") as? HYT_DatePickerVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.delegate = self
        vc?.flags = "ToDate"
        present(vc!, animated: true)
    }
    @IBAction func didtappedFromDateBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_DatePickerVC") as? HYT_DatePickerVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.delegate = self
        vc?.flags = "FromDate"
        present(vc!, animated: true)
    }
    
    @IBAction func didTappedSelectPromotionBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_DropDownVC") as? HYT_DropDownVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.delegate1 = self
        vc?.flags = flags
        present(vc!, animated: true)
    }
   
    
    @IBAction func didTappedResetBtn(_ sender: UIButton) {
        selectPromotionNameLbl.text = "Select"
        fromDateLbl.text = "From Date"
        toDateLbl.text = "To Date"
        fromDate = ""
        toDate = ""
    }

    @IBAction func didTappedFilterBtn(_ sender: UIButton) {
        
        if fromDateLbl.text == "From Date" || toDateLbl.text == "To Date"{
            self.view.makeToast("Select date", duration: 2.0, position: .center)
        }else if fromDate > toDate {
            self.view.makeToast("invalid date range", duration: 2.0, position: .center)
        }else{
            delegate?.didTappedFilterBtn(item: self)
            dismiss(animated: true)
        }
        
        
    }
    
    @IBAction func didTappedCloseBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }

}
