//
//  HYT_LanguageDropDownVC.swift
//  Hoya Thailand
//
//  Created by syed on 14/02/23.
//

import UIKit
import LanguageManager_iOS

protocol LanguageDropDownDelegate{
    func didtappedLanguageBtn(item: HYT_LanguageDropDownVC )
}

class HYT_LanguageDropDownVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var languageTV: UITableView!
    @IBOutlet weak var chooseLngLbl: UILabel!
    
    var languageList : [LanguageModel] = [LanguageModel(languageName: "EN", languageImage: "EN-Language"),
                                          LanguageModel(languageName: "TH", languageImage: "TH-Language")
    ]
    var delegate: LanguageDropDownDelegate?
    var language = ""
    var languageId = 0
    var VM = LanguageVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.VM.VC = self
        languageTV.delegate = self
        languageTV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        languageListApi()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        if touch?.view == self.view{
//                    dismiss(animated: true)
//        }
//    }
    
    
    @IBAction func didTappedCloseBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    
    
//    MARK: - LanguageList Api
    func languageListApi(){
        let parameter : [String : Any ] = [
                "ActionType": 24
        ]
        VM.languageListApi(parameter: parameter)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.languageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_LanguageTVCell", for: indexPath) as! HYT_LanguageTVCell
        cell.selectionStyle = .none
        cell.languageLbl.text = VM.languageList[indexPath.row].attributeValue//languageList[indexPath.row].languageName
        cell.languageImage.image = UIImage(named: languageList[indexPath.row].languageImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        language = languageList[indexPath.row].languageName
        languageId = VM.languageList[indexPath.row].attributeId ?? 1
        UserDefaults.standard.set(language, forKey: "LanguageName")
        UserDefaults.standard.set(languageId, forKey: "LanguageId")
        if languageId == 1{
            LanguageManager.shared.setLanguage(language: .en)
        }else if languageId == 5{
            LanguageManager.shared.setLanguage(language: .th)
        }
        
        delegate?.didtappedLanguageBtn(item: self)
        dismiss(animated: true)
    }
}




struct LanguageModel{
    let languageName: String
    let languageImage: String
}
