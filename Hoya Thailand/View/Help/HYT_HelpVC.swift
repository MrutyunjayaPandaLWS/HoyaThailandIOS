//
//  HYT_HelpVC.swift
//  Hoya Thailand
//
//  Created by syed on 10/02/23.
//

import UIKit
import Toast_Swift
import AVFoundation
import Photos
import LanguageManager_iOS

class HYT_HelpVC: BaseViewController, TopicListDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func topicName(item: HYT_LQTopicListVC) {
        selectQueryTopicLbl.text = item.topicName
            self.selectTopicId = item.selectTopicId
        selectQueryTopicLbl.textColor = .black
    }
    
    @IBOutlet weak var queryImageHeight: NSLayoutConstraint!
    @IBOutlet weak var queryImage: UIImageView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var uploadImageLbl: UILabel!
    @IBOutlet weak var uploadImageTitleLbl: UILabel!
    @IBOutlet weak var querySummeryLbl: UILabel!
    @IBOutlet weak var querySummeryTF: UITextField!
    @IBOutlet weak var queryTopicTitleLbl: UILabel!
    @IBOutlet weak var selectQueryTopicLbl: UILabel!
    @IBOutlet weak var membershipIdLbl: UILabel!
    @IBOutlet weak var membershipIdTF: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var uploadImageView: UIView!
    
    let imagePicker = UIImagePickerController()
    var strdata1 = ""
    var selectTopicId = 0
    var mobileNumberExistancy: Int = -1
    var actorId:String = ""
    
var VM = HYT_HelpVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
    
        imagePicker.delegate = self
        localization()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        localization()
    }

    @IBAction func didTappedSelectQueryTopicBtn(_ sender: UIButton) {
        if membershipIdTF.text?.count == 0{
            self.view.makeToast("Enter membershipID",duration: 2.0,position: .center)
        }else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_LQTopicListVC") as? HYT_LQTopicListVC
            vc?.modalTransitionStyle = .crossDissolve
            vc?.modalPresentationStyle = .overFullScreen
            vc?.delegate = self
            present(vc!, animated: true)
        }
       

    }
    @IBAction func didTappedSubmitBtn(_ sender: UIButton) {
        if membershipIdTF.text?.count == 0 {
            self.view.makeToast("membershipId_toast_message".localiz(), duration: 2.0, position: .center)
        }else if selectQueryTopicLbl.text == "Select Query Topic"{
            self.view.makeToast("queryTopic_toast_message".localiz(), duration: 2.0, position: .center)
        } else if querySummeryTF.text?.count == 0 {
            self.view.makeToast("query_summery_toast_message".localiz(), duration: 2.0, position: .center)
        }else if mobileNumberExistancy == -1{
            self.view.makeToast("userId_toast_message".localiz(), duration: 2.0, position: .center)
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
//            newQuerySubmission()
        }

    }
    
    @IBAction func didTappedMembershipIdTF(_ sender: UITextField) {
        
        mobileNumberExistancyApi()
    }
    @IBAction func didTappedUlpoadImageBtn(_ sender: UIButton) {
        
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
    
    @IBAction func didTappedBackBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func retriveActorId(){
        let parameter : [String : Any] = [
            
                "ActionType": 276,
                "Location":[
                    "UserName": membershipIdTF.text ?? ""
                ]
        ]
        self.VM.retriveUserId(parameter: parameter)
    }
    
    func mobileNumberExistancyApi(){
        let parameter : [String : Any] = [
                "ActionType": "57",
                "Location": [
                    "UserName" : "\(membershipIdTF.text ?? "")"
                ]
        ]
        VM.verifyMobileNumberAPI(paramters: parameter)
//        56875434356
    }
    
    func newQuerySubmission(){
        let parameter : [String : Any] = [
                "ActionType": "0",
                "ActorId": actorId,
                "CustomerName": "",
                "Email": "",
                "HelpTopic": selectQueryTopicLbl.text ?? "" ,
                "HelpTopicID": "\(selectTopicId)",
                "ImageUrl": strdata1,
                "IsQueryFromMobile": "true",
                "LoyaltyID": membershipIdTF.text ?? "",
                "QueryDetails": querySummeryTF.text ?? "",
                "QuerySummary": querySummeryTF.text ?? "",
                "SourceType": "3"

        ]
        self.VM.newQuerySubmission(parameter: parameter)
    }
    
  
}

//MARK: - ImagePicker
extension HYT_HelpVC{
    
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
        titleLbl.text = "help".localiz()
        membershipIdLbl.text = "membershipId".localiz()
        membershipIdTF.placeholder = "membershipId_toast_message".localiz()
        queryTopicTitleLbl.text = "queryTopic".localiz()
//        selectQueryTopicLbl.text = "queryTopic_toast_message".localiz()
        querySummeryLbl.text = "query_summery".localiz()
        querySummeryTF.placeholder = "query_summery_toast_message".localiz()
        uploadImageLbl.text = "uploadImage".localiz()
        submitBtn.setTitle("submit".localiz(), for: .normal)
        uploadImageTitleLbl.text = "upload_a_proof".localiz()
    }
    
}
