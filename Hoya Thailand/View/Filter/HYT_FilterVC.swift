//
//  HYT_FilterVC.swift
//  Hoya Thailand
//
//  Created by syed on 10/02/23.
//

import UIKit
import Toast_Swift
import LanguageManager_iOS

protocol FilterProtocolDelegate{
    func didTappedFilterBtn(item: HYT_FilterVC)
    func didTappedResetFilterBtn(item: HYT_FilterVC)
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
        statusId = "\(item.statusId)"
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
    var  tagName = 0
    var selectStatusEnable = true
    var fromDate = ""
    var toDate = ""
    var flags = ""
    var statusName = ""
    var statusId = "-1"
    var statusTitle = "select_status".localiz()
    override func viewDidLoad() {
        super.viewDidLoad()
        promotionNameViewHeight.constant = CGFloat(promotionNameHeight)
        bottomConstraints.constant = CGFloat(bottomConstraintsValue)
        if statusName != ""{
            selectPromotionNameLbl.text = statusName
        }else{
            if tagName == 0{
                selectPromotionNameLbl.text = "select_status".localiz()
                statusTitle = "select_status".localiz()
            }else if tagName == 1{
                selectPromotionNameLbl.text = "selectPromotionName".localiz()
                statusTitle = "selectPromotionName".localiz()
            }
//            else if tagName == 2{
//                selectPromotionNameLbl.text = "Select Promotion Name"
//                statusTitle = "Select Promotion Name"
//            }
        }
        if fromDate != ""{
            fromDateLbl.text = fromDate
        }else{
            fromDateLbl.text = "fromDate".localiz()
        }
        if toDate != ""{
            toDateLbl.text = toDate
        }else{
            toDateLbl.text = "toDate".localiz()
        }
        localization()
    }
    
    
    private func localization(){
        filterLbl.text = "filter".localiz()
        filterBtn.setTitle("filter".localiz(), for: .normal)
        resetBtn.setTitle("reset".localiz(), for: .normal)
        
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
        fromDateLbl.text = "fromDate".localiz()
        toDateLbl.text = "toDate".localiz()
        fromDate = ""
        toDate = ""
        statusName = ""
        if tagName == 0{
            selectPromotionNameLbl.text = "select_status".localiz()
            statusTitle = "select_status".localiz()
        }else if tagName == 1{
            selectPromotionNameLbl.text = "selectPromotionName".localiz()
            statusTitle = "selectPromotionName".localiz()
        }else if tagName == 2{
            selectPromotionNameLbl.text = "selectPromotionName".localiz()
            statusTitle = "selectPromotionName".localiz()
        }
        delegate?.didTappedResetFilterBtn(item: self)
    }
    
    @IBAction func didTappedFilterBtn(_ sender: UIButton) {

        if self.fromDateLbl.text == "fromDate".localiz() && self.toDateLbl.text == "toDate".localiz() && self.selectPromotionNameLbl.text == statusTitle && selectStatusEnable == true{
            if tagName == 1{
                self.view.makeToast("Select Promotion Name or Date Range or both".localiz(), duration: 2.0, position: .center)
            }else{
                self.view.makeToast("Select Status or Date Range or both".localiz(), duration: 2.0, position: .center)
            }
            
        }else if self.fromDateLbl.text == "fromDate".localiz() && self.toDateLbl.text == "toDate".localiz() && selectStatusEnable == false{
                self.view.makeToast("filter_toast_message".localiz(), duration: 2.0, position: .center)
        }else if self.fromDateLbl.text == "fromDate".localiz() && self.toDateLbl.text == "toDate".localiz() && self.selectPromotionNameLbl.text != statusTitle{
            
            delegate?.didTappedFilterBtn(item: self)
            dismiss(animated: true)
            
        }else if self.fromDateLbl.text != "fromDate".localiz() && self.toDateLbl.text == "toDate".localiz(){
            
            self.view.makeToast("Select ToDate".localiz(), duration: 2.0, position: .center)
            
        }else if self.fromDateLbl.text == "fromDate".localiz() && self.toDateLbl.text != "toDate".localiz(){
            
            self.view.makeToast("Select From Date".localiz(), duration: 2.0, position: .center)
            
        }else if self.fromDateLbl.text != "fromDate".localiz() && self.toDateLbl.text != "toDate".localiz() && self.selectPromotionNameLbl.text == statusTitle || self.selectPromotionNameLbl.text != statusTitle{
            
            if toDate < fromDate{
                
                self.view.makeToast("ToDate should be lower than FromDate".localiz(), duration: 2.0, position: .center)
                
            }else if self.fromDateLbl.text == "fromDate".localiz() && self.toDateLbl.text == "toDate".localiz() && self.selectPromotionNameLbl.text != statusTitle{
                
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
