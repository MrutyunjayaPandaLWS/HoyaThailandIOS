//
//  BaseViewController.swift
//  Quba Safalta
//
//  Created by Arokia-M3 on 06/03/21.
//

import UIKit
import Lottie
import Toast_Swift

class BaseViewController: UIViewController {
    
    var customerTypeID = UserDefaults.standard.integer(forKey: "customerTypeID")
    var selectedLanguage = UserDefaults.standard.string(forKey: "LanguageName") ?? "EN"
    var selectedLanguageId = UserDefaults.standard.string(forKey: "LanguageId") ?? "-1"
    var userId = UserDefaults.standard.integer(forKey: "userId")
    var loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyId") ?? ""
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
//    var animationView1: AnimationView?
    var redeemablePointBal = UserDefaults.standard.integer(forKey: "TotalPoints")
    var firstName = UserDefaults.standard.string(forKey: "FirstName")
    var customerEmail = UserDefaults.standard.string(forKey: "CustomerEmail")
    var customerMobileNumber = UserDefaults.standard.string(forKey: "Mobile")

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func convertDateFormater(_ date: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "dd/MM/yyyy"
        return  dateFormatter.string(from: date!)
 
        }
    
    func convertDateFromatListing(_ date: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d yyyy h:mma"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "dd/MM/yyyy"
        return  dateFormatter.string(from: date!)
 
        }
    
    func convertDateFromatListing2(_ date: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyy HH:mm:ss a"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "dd/MM/yyyy"
        return  dateFormatter.string(from: date!)
 
        }
    
       func startLoading(){
        DispatchQueue.main.async {
            self.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.activityIndicator.center = self.view.center;
            self.activityIndicator.hidesWhenStopped = true;
            self.activityIndicator.color = UIColor.black
            self.view.addSubview(self.activityIndicator);
            self.activityIndicator.startAnimating();
            self.view.isUserInteractionEnabled = true
        }
       }
       func stopLoading(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating();
            self.view.isUserInteractionEnabled = true
        }
          
       }

    func alertmsg(alertmsg:String, buttonalert:String){
        let alert = UIAlertController(title: "", message: alertmsg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "\(buttonalert)", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}
