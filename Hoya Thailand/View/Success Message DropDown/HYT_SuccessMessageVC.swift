//
//  HYT_SuccessMessageVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import LanguageManager_iOS

protocol SuccessMessageDelegate{
    func goToLoginPage()
}

class HYT_SuccessMessageVC: UIViewController {

    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var messageStatusLbl: UILabel!
    var successMessage : String = ""
    var delegate : SuccessMessageDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        messageLbl.text = successMessage
        messageStatusLbl.text = "congratulations".localiz()
    }
    
    @IBAction func didTappedOkBtn(_ sender: UIButton) {
        dismiss(animated: true)
        delegate?.goToLoginPage()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view{
                    dismiss(animated: true)
        }
    }
}
