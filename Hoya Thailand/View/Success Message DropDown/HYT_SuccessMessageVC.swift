//
//  HYT_SuccessMessageVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import LanguageManager_iOS

protocol SuccessMessageDelegate{
    func goToLoginPage(item: HYT_SuccessMessageVC)
}

class HYT_SuccessMessageVC: UIViewController {

    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var messageStatusLbl: UILabel!
    var successMessage : String = ""
    var itsComeFrom : String = ""
    var delegate : SuccessMessageDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        switch itsComeFrom{
        case "0":
            messageStatusLbl.isHidden = true
        case "1":
            messageStatusLbl.isHidden = true
        default:
            messageStatusLbl.isHidden =  false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        messageLbl.text = successMessage
        messageStatusLbl.text = "congratulations".localiz()
        okBtn.setTitle("Ok".localiz(), for: .normal)
    }
    
    @IBAction func didTappedOkBtn(_ sender: UIButton) {
        dismiss(animated: true){
            self.delegate?.goToLoginPage(item: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view{
                    dismiss(animated: true)
        }
    }
}
