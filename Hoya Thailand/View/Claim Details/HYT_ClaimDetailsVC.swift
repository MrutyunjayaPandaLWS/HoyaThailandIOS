//
//  HYT_ClaimDetailsVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import Toast_Swift

class HYT_ClaimDetailsVC: UIViewController {

    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var cancelBtnView: UIView!
    @IBOutlet weak var scanBarcodeView: UIView!
    @IBOutlet weak var claimDetailsView: UIView!
    @IBOutlet weak var scanCodeLbl: UILabel!
    @IBOutlet weak var uploadCodeLbl: UILabel!
    @IBOutlet weak var validityDateLbl: UILabel!
    @IBOutlet weak var validityDateTitle: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var quantityTF: UITextField!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var productNameTF: UITextField!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var invoiceNumberTF: UITextField!
    @IBOutlet weak var invoiceNumberLbl: UILabel!
    @IBOutlet weak var claimDetailsLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scanBarcodeView.isHidden = false
        claimDetailsView.isHidden = true
        uploadCodeLbl.backgroundColor = .white
        uploadCodeLbl.textColor = .black
        scanCodeLbl.backgroundColor = primaryColor
        scanCodeLbl.textColor = .white
        cancelBtn.isHidden = false
    }
    
    @IBAction func didTappedScanCodeBtn(_ sender: UIButton) {
        claimDetailsView.isHidden = true
        scanBarcodeView.isHidden = false
        uploadCodeLbl.backgroundColor = .white
        uploadCodeLbl.textColor = .black
        scanCodeLbl.backgroundColor = primaryColor
        scanCodeLbl.textColor = .white
        cancelBtnView.isHidden = false
        cancelBtn.isHidden = false
        
    }
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedSubmitBtn(_ sender: UIButton) {
        if invoiceNumberTF.text?.count == 0 {
            self.view.makeToast("Enter your invoice number", duration: 2.0, position: .center)
        }else if productNameTF.text?.count == 0{
            self.view.makeToast("Enter the product name", duration: 2.0, position: .center)
        }else if quantityTF.text?.count == 0{
            self.view.makeToast("Enter a quantity", duration: 2.0, position: .center)
        }else{
            successMessagePopUp(message: "Claim request has been submitted successfully")
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func didTappedCancelBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedUplaodBtn(_ sender: UIButton) {
        claimDetailsView.isHidden = false
        scanBarcodeView.isHidden = true
        uploadCodeLbl.backgroundColor = primaryColor
        uploadCodeLbl.textColor = .white
        scanCodeLbl.backgroundColor = .white
        scanCodeLbl.textColor = .black
        cancelBtn.isHidden = true
        cancelBtnView.isHidden = true
    }
}
