//
//  HYT_WelcomeVC.swift
//  Hoya Thailand
//
//  Created by syed on 09/02/23.
//

import UIKit
import LanguageManager_iOS

class HYT_WelcomeVC: UIViewController {

    @IBOutlet weak var thailandLanguageLbl: UILabel!
    @IBOutlet weak var englisLanguageLbl: UILabel!
    @IBOutlet weak var selectLanguageLbl: UILabel!
    @IBOutlet weak var letsGetStatedLbl: UILabel!
    @IBOutlet weak var welcomeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTappedThailandLngBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_LoginVC") as? HYT_LoginVC
        UserDefaults.standard.set("TH", forKey: "LanguageName")
        LanguageManager.shared.setLanguage(language: .th)
        UserDefaults.standard.synchronize()
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func didTappedEnglishLngBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_LoginVC") as? HYT_LoginVC
        UserDefaults.standard.set("EN", forKey: "LanguageName")
        LanguageManager.shared.setLanguage(language: .en)
        UserDefaults.standard.synchronize()
        navigationController?.pushViewController(vc!, animated: true)
    }
}
