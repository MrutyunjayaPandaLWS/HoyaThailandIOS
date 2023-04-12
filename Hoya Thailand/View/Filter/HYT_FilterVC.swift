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

class HYT_FilterVC: UIViewController, DateSelectedDelegate, FilterStatusDelegate {
    func acceptDate(_ vc: HYT_DatePickerVC) {
        if vc.isComeFrom == "1"{
            fromDate = vc.selectedDate
            fromDateLbl.text = vc.selectedDate
        }else{
            toDate = vc.selectedDate
            toDateLbl.text = vc.selectedDate
        }
    }
    
    func declineDate(_ vc: HYT_DatePickerVC) {}
    
    func didTappedFilterStatus(item: HYT_DropDownVC) {
        statusName = item.statusName
        statusId = item.statusId
        selectPromotionNameLbl.text = statusName
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
    var statusId = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        promotionNameViewHeight.constant = CGFloat(promotionNameHeight)
        bottomConstraints.constant = CGFloat(bottomConstraintsValue)
        selectPromotionNameLbl.text = "Select Status"
    }
    
    @IBAction func didTappedTodateBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_DatePickerVC") as? HYT_DatePickerVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.delegate = self
        vc?.isComeFrom = "2"
        present(vc!, animated: true)
    }
    @IBAction func didtappedFromDateBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_DatePickerVC") as? HYT_DatePickerVC
        vc?.modalTransitionStyle = .crossDissolve
        vc?.modalPresentationStyle = .overFullScreen
        vc?.delegate = self
        vc?.isComeFrom = "1"
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
        selectPromotionNameLbl.text = "Select Status"
        fromDateLbl.text = "From Date"
        toDateLbl.text = "To Date"
        fromDate = ""
        toDate = ""
    }
    
    @IBAction func didTappedFilterBtn(_ sender: UIButton) {
        
        //        if fromDateLbl.text == "From Date" && toDateLbl.text == "To Date" && selectPromotionNameLbl.text == "Select"{
        //            if fromDate > toDate {
        //                self.view.makeToast("invalid date range", duration: 2.0, position: .center)
        //            }else{
        //                delegate?.didTappedFilterBtn(item: self)
        //                dismiss(animated: true)
        //            }
        //        } else{
        //            self.view.makeToast("Select date or Status or both", duration: 2.0, position: .center)
        //        }
        //
        
        if self.fromDateLbl.text == "From Date" && self.toDateLbl.text == "To Date" && self.selectPromotionNameLbl.text == "Select Status"{
            self.view.makeToast("Select date Date Range", duration: 2.0, position: .center)
        }else if self.fromDateLbl.text == "From Date" && self.toDateLbl.text == "To Date" && self.selectPromotionNameLbl.text != "Select Status"{
            
            delegate?.didTappedFilterBtn(item: self)
            dismiss(animated: true)
            
        }else if self.fromDateLbl.text != "From Date" && self.toDateLbl.text == "To Date"{
            
            self.view.makeToast("Select ToDate", duration: 2.0, position: .center)
            
        }else if self.fromDateLbl.text == "From Date" && self.toDateLbl.text != "To Date"{
            
            self.view.makeToast("Select From Date", duration: 2.0, position: .center)
            
        }else if self.fromDateLbl.text != "From Date" && self.toDateLbl.text != "To Date" && self.selectPromotionNameLbl.text == "Select Status" || self.selectPromotionNameLbl.text != "Select Status"{
            
            if toDate < fromDate{
                
                self.view.makeToast("ToDate should be lower than FromDate", duration: 2.0, position: .center)
                
            }else if self.fromDateLbl.text == "From Date" && self.toDateLbl.text == "To Date" && self.selectPromotionNameLbl.text != "Select Status"{
                
                delegate?.didTappedFilterBtn(item: self)
                dismiss(animated: true)
            }else{
                delegate?.didTappedFilterBtn(item: self)
                dismiss(animated: true)
            }
            
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
    //
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        let touch = touches.first
    //        if touch?.view == self.view{
    //                    dismiss(animated: true)
    //        }
    //    }
    
}
