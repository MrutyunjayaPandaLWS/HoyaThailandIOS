//
//  HYT_CreateQueryVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import AVFoundation
import Photos
import LanguageManager_iOS

class HYT_CreateQueryVC: BaseViewController,TopicListDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func topicName(item: HYT_LQTopicListVC) {
        selectTopicLbl.text = item.topicName
        selectTopicId = item.selectTopicId
    }

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var browseImageBtn: UIButton!
    @IBOutlet weak var queryImage: UIImageView!
    @IBOutlet weak var queryDetailsTF: UITextField!
    @IBOutlet weak var querySummeryTF: UITextField!
    @IBOutlet weak var querySummeryLbl: UILabel!
    @IBOutlet weak var selectTopicLbl: UILabel!
    @IBOutlet weak var selectTopicHeadingLbl: UILabel!
    @IBOutlet weak var queryDescriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    var strdata1 = ""
    var queryName = "Select query"
    let imagePicker = UIImagePickerController()
    var VM = HYT_NewQuerySubmissionVM()
    var selectTopicId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        imagePicker.delegate = self
        selectTopicLbl.text = queryName
        localization()
    }
    
    @IBAction func didTappedSubmitBtn(_ sender: UIButton) {
        if selectTopicLbl.text == "queryTopic_toast_message".localiz(){
            self.view.makeToast("queryTopic_toast_message".localiz(), duration: 2.0, position: .center)
        } else if querySummeryTF.text?.count == 0 {
            self.view.makeToast("query_summery_toast_message".localiz(), duration: 2.0, position: .center)
        }else if queryDetailsTF.text?.count == 0 {
            self.view.makeToast("queryDetails_toast_message".localiz(), duration: 2.0, position: .center)
        }else{
            if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
                DispatchQueue.main.async{
                    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_Internet_Check") as! IOS_Internet_Check
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                }
            }else{
                newQuerySubmission()
            }
        }
        
        
        
        
    }
    @IBAction func didTappedBrowseBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose any option", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler:{ (UIAlertAction)in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBOutlet weak var queryDetailsHeadingLbl: UILabel!
    
    @IBAction func didTappedSelectTopicBtn(_ sender: UIButton) {
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_Internet_Check") as! IOS_Internet_Check
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_LQTopicListVC") as? HYT_LQTopicListVC
            vc?.modalPresentationStyle = .overFullScreen
            vc?.modalTransitionStyle = .crossDissolve
            vc?.delegate = self
            present(vc!, animated: true)
        }
        
        
    }
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func newQuerySubmission(){
        let parameter : [String : Any] = [
                "ActionType": "0",
                "ActorId": userId,
                "CustomerName": "",
                "Email": "",
                "HelpTopic": queryName ,
                "HelpTopicID": "\(selectTopicId)",
                "ImageUrl": strdata1,
                "IsQueryFromMobile": "true",
                "LoyaltyID": loyaltyId,
                "QueryDetails": queryDetailsTF.text ?? "",
                "QuerySummary": querySummeryTF.text ?? "",
                "SourceType": "3"

        ]
        self.VM.newQuerySubmission(parameter: parameter)
    }

}

extension HYT_CreateQueryVC{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            queryImage.image = imagePicked.resized(withPercentage: 0.5)
            queryImage.contentMode = .scaleAspectFit
            let imageData = imagePicked.resized(withPercentage: 0.1)
            let imageData1: NSData = imageData!.pngData()! as NSData
            self.strdata1 = imageData1.base64EncodedString(options: .lineLength64Characters)
        }
        dismiss(animated: true)
    }
    
    func openCamera(){
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                    if response {
                        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
                            DispatchQueue.main.async {
                                self.imagePicker.allowsEditing = false
                                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                                self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: self.imagePicker.sourceType)!
                                self.imagePicker.sourceType = .camera
                                self.imagePicker.mediaTypes = ["public.image"]
                                self.present(self.imagePicker,animated: true,completion: nil)
                            }
                        }            } else {
                            DispatchQueue.main.async {
                                let alertVC = UIAlertController(title: "Need Camera Access", message: "Allow Camera Access", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Allow", style: UIAlertAction.Style.default) {
                                    UIAlertAction in
                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                }
                                let cancelAction = UIAlertAction(title: "DisAllow", style: UIAlertAction.Style.cancel) {
                                    UIAlertAction in
                                }
                                alertVC.addAction(okAction)
                                alertVC.addAction(cancelAction)
                                self.present(alertVC, animated: true, completion: nil)
                            }
                        }
                }} else {
                    self.noCamera()
                }
        }
    }
    
    func noCamera(){
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "No Camera", message: "Sorry no device", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        DispatchQueue.main.async {
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                if newStatus ==  PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async {
                        self.imagePicker.allowsEditing = false
                        self.imagePicker.sourceType = .photoLibrary
//                        self.imagePicker.mediaTypes = ["public.image"]
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                }else{
                    DispatchQueue.main.async {
                        let alertVC = UIAlertController(title: "Need Gallary access", message: "Allow Gallery Access", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Allow", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        }
                        let cancelAction = UIAlertAction(title: "DisAllow", style: UIAlertAction.Style.cancel) {
                            UIAlertAction in
                        }
                        alertVC.addAction(okAction)
                        alertVC.addAction(cancelAction)
                        self.present(alertVC, animated: true, completion: nil)
                    }
                }
            })
        }
        
    }
    
    private func localization(){
        queryDescriptionLbl.text = "newQueryInfo".localiz()
        selectTopicHeadingLbl.text = "queryTopic".localiz()
//        selectTopicLbl.text = "queryTopic_toast_message".localiz()
        querySummeryLbl.text = "query_summery".localiz()
        querySummeryTF.placeholder = "query_summery_toast_message".localiz()
        queryDetailsHeadingLbl.text = "queryDetails".localiz()
        queryDetailsTF.placeholder = "queryDetails_toast_message".localiz()
        browseImageBtn.setTitle("browse_image".localiz(), for: .normal)
        submitBtn.setTitle("submit_query".localiz(), for: .normal)
        titleLbl.text = "query".localiz()
        
    }
}
