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
    
    let LoaderAnimation = "loaderScreen"
    var loaderAnimationView: LottieAnimationView?
    var shadowView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loaderAnimation()
    }
    
    func loaderAnimation(){
        
        loaderAnimationView = .init(name: LoaderAnimation)
        loaderAnimationView!.frame = view.bounds
        loaderAnimationView!.contentMode = .scaleAspectFit
        loaderAnimationView!.loopMode = .loop
        loaderAnimationView!.animationSpeed = 0.5
    }
    
    
    func configure(){
        self.shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.shadowView.translatesAutoresizingMaskIntoConstraints = false
        self.view?.addSubview(shadowView)
        
        self.shadowView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.shadowView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.shadowView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.shadowView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.loaderAnimationView?.translatesAutoresizingMaskIntoConstraints = false
        self.shadowView.addSubview(loaderAnimationView!)
        self.loaderAnimationView?.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.loaderAnimationView?.widthAnchor.constraint(equalToConstant: 200).isActive = true

        self.loaderAnimationView?.centerXAnchor.constraint(equalTo: self.shadowView.centerXAnchor).isActive = true
        self.loaderAnimationView?.centerYAnchor.constraint(equalTo: self.shadowView.centerYAnchor).isActive = true
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
               self.configure()
               self.loaderAnimationView!.play()
               self.view.isUserInteractionEnabled = true
           }
       }
       func stopLoading(){
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.loaderAnimationView!.stop()
                self.loaderAnimationView?.removeFromSuperview()
               self.shadowView.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
            })
          
       }

    func alertmsg(alertmsg:String, buttonalert:String){
        let alert = UIAlertController(title: "", message: alertmsg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "\(buttonalert)", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func lottieAnimation( animationView: LottieAnimationView){
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()

    }


}
