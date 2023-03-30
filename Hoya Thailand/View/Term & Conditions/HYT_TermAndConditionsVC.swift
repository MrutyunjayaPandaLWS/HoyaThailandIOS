//
//  HYT_TermAndConditionsVC.swift
//  Hoya Thailand
//
//  Created by syed on 29/03/23.
//

import UIKit
import WebKit

protocol CheckBoxSelectDelegate{
    func accept(_ vc: HYT_TermAndConditionsVC)
    func decline(_ vc: HYT_TermAndConditionsVC)
}

class HYT_TermAndConditionsVC: BaseViewController {

    @IBOutlet weak var titleVC: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    var delegate : CheckBoxSelectDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
//            self.startLoading()
            guard let filePath = Bundle.main.path(forResource: "TandC-Johnson samriddhi", ofType: "html")
                else {
                    // File Error
                    print ("File reading error")
                    return
            }

            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl1 = URL(fileURLWithPath: filePath)
            webView.loadHTMLString(contents as String, baseURL: baseUrl1)
            DispatchQueue.main.async {
//                self.stopLoading()
            }
            
        }
        catch {
            print ("File HTML error")
        }
    }
    @IBAction func selectAcceptBtn(_ sender: UIButton) {
        delegate?.accept(self)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectDeclineBtn(_ sender: UIButton) {
        delegate?.decline(self)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
