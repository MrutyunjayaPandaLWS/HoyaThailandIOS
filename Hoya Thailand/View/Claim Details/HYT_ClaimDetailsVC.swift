//
//  HYT_ClaimDetailsVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import Toast_Swift
import Firebase
import AVFoundation
import CoreLocation
import Lottie

class HYT_ClaimDetailsVC: BaseViewController,AVCaptureVideoDataOutputSampleBufferDelegate,CLLocationManagerDelegate, FilterStatusDelegate {
    func didTappedFilterStatus(item: HYT_DropDownVC) {
        productNameTF.text = item.statusName
        productName = item.statusName
        productCode = item.statusId
    }
    
//    func didTappedPromotionName(item: HYT_DropDownVC) {
//        productNameTF.text = item.statusName
//        productName = item.statusName
//        productCode = item.statusId
////        flags = ""
////        productValidationApi(productId: item.statusId)
//    }
//
//    func didTappedGenderBtn(item: HYT_DropDownVC) {}
//
//    func didTappedAccountType(item: HYT_DropDownVC) {}
//
//    func didTappedRoleBtn(item: HYT_DropDownVC) {}
//
//    func didTappedSalesRepresentative(item: HYT_DropDownVC) {}
    
    

    @IBOutlet weak var scannerAnimationView: LottieAnimationView!
    @IBOutlet weak var userDetailsView: UIView!
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
    var VM = HYT_ClaimDetailsVM()
    var promotionData : LtyPrgBaseDetails?
    var isscannedOnce = false
    let session = AVCaptureSession()
    lazy var vision = Vision.vision()
    var locationManager = CLLocationManager()
    var currentlocation:CLLocation!
    var barcodeDetector :VisionBarcodeDetector?
    var qrList = [String]()
    var invoiceNumber = ""
    var scanCodeStatus = -1
    var productCodeStatus = -1
    var salesReturnStatus = -1
    var productName = ""
    var productCode = 0
    var productAndInvoiceValidation = "false"
    var flags = ""
    var timmer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        lottieAnimation(animationView: scannerAnimationView)
        scanBarcodeView.isHidden = false
        userDetailsView.isHidden = true
        claimDetailsView.isHidden = true
        uploadCodeLbl.backgroundColor = .white
        uploadCodeLbl.textColor = .black
        scanCodeLbl.backgroundColor = primaryColor
        scanCodeLbl.textColor = .white
        cancelBtnView.isHidden = true
        cancelBtn.isHidden = true
        customerNameLbl.text = promotionData?.programName
        validityDateLbl.text = "\(promotionData?.jEndDate?.prefix(10) ?? "")"
        quantityTF.keyboardType = .numberPad
        scannerSetup()
    }
    
    @IBAction func didTappedScanCodeBtn(_ sender: UIButton) {
        session.startRunning()
        scannerAnimationView.isHidden = false
        userDetailsView.isHidden = true
        claimDetailsView.isHidden = true
        scanBarcodeView.isHidden = false
        uploadCodeLbl.backgroundColor = .white
        uploadCodeLbl.textColor = .black
        scanCodeLbl.backgroundColor = primaryColor
        scanCodeLbl.textColor = .white
//        cancelBtnView.isHidden = false
//        cancelBtn.isHidden = false
        
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
        }else if scanCodeStatus == -1{
            self.view.makeToast("Invoice number already exist", duration: 2.0, position: .center)
        }else if productCodeStatus == -1{
            self.view.makeToast("Summitted Len Design is not available", duration: 2.0, position: .center)
        }else if salesReturnStatus == -1{
            self.view.makeToast("Invalid claim request", duration: 2.0, position: .center)
        }else if productAndInvoiceValidation == "false"{
            self.view.makeToast("Invalid claim request", duration: 2.0, position: .center)
        }else{
            invoiceNumberCheckApi(invoiceNumber: invoiceNumberTF.text ?? "")
        }
        
    }
    
    @IBAction func didTappedCancelBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedUplaodBtn(_ sender: UIButton) {
        scannerAnimationView.isHidden = true
        claimDetailsView.isHidden = false
        userDetailsView.isHidden = false
        scanBarcodeView.isHidden = true
        uploadCodeLbl.backgroundColor = primaryColor
        uploadCodeLbl.textColor = .white
        scanCodeLbl.backgroundColor = .white
        scanCodeLbl.textColor = .black
//        cancelBtn.isHidden = true
//        cancelBtnView.isHidden = true
    }
    
    @IBAction func endEdditingInvoiceNumberTF(_ sender: UITextField) {
//        flags = ""
//        if invoiceNumberTF.text?.count == 0{
//            self.view.makeToast("Enter invoice number",duration: 2.0,position: .center)
//        }else{
//            invoiceNumberCheckApi(invoiceNumber: invoiceNumberTF.text ?? "")
//            productNameTF.text = ""
//            productCode = 0
//            productName = ""
//        }
        
        
    }
    
    @IBAction func endEdditingProductNameTF(_ sender: UITextField) {
    }
    
    @IBAction func selectProductNameBtn(_ sender: UIButton) {
//        if invoiceNumberTF.text?.count == 0{
//            self.view.makeToast("Enter the invoice number",duration: 2.0,position: .center)
//        }else if scanCodeStatus != 1{
//            self.view.makeToast("Enter a valid invoice number",duration: 2.0,position: .center)
//        }else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_DropDownVC") as? HYT_DropDownVC
            vc?.modalPresentationStyle = .overFullScreen
            vc?.modalTransitionStyle = .crossDissolve
            vc?.flags = "productList"
            vc?.progrmaId = promotionData?.programId ?? 0
            vc?.delegate1 = self
            present(vc!, animated: true)
//        }

    }
    
    
    
}

extension HYT_ClaimDetailsVC{
    
    func authorizelocationstates(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentlocation = locationManager.location
            print(currentlocation)
        }
        else{
            // Note : This function is overlap permission
            locationManager.requestWhenInUseAuthorization()
            authorizelocationstates()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager = manager
        authorizelocationstates()
    }
    
    func scannerSetup(){
        
        self.barcodeDetector = vision.barcodeDetector()
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted == true {
            } else {
            }
        })
        
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized{
                startLiveVideo()
            }else{
                print("permission denied")
                let alertVC = UIAlertController(title: "Hoya Application need Camera permission for Scanning Codes", message: "Allow Camera Access", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Allow", style: UIAlertAction.Style.default) {
                    UIAlertAction in
//                    UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    self.startLiveVideo()
                }
                let cancelAction = UIAlertAction(title: "DisAllow", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    
                }
                alertVC.addAction(okAction)
                alertVC.addAction(cancelAction)
                self.present(alertVC, animated: true, completion: nil)
            }
    }
    
    func startLiveVideo(){
        DispatchQueue.main.async {
            self.session.sessionPreset = AVCaptureSession.Preset.photo
            let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
            let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
            let deviceOutput = AVCaptureVideoDataOutput()
            deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
            self.session.addInput(deviceInput)
            self.session.addOutput(deviceOutput)
            let imageLayer = AVCaptureVideoPreviewLayer(session: self.session)
            imageLayer.frame = CGRect(x: 0, y: 0, width: self.scanBarcodeView.frame.size.width, height: self.scanBarcodeView.frame.size.height)
            imageLayer.videoGravity = .resizeAspectFill
            self.scanBarcodeView.layer.addSublayer(imageLayer)
            self.session.startRunning()
            self.isscannedOnce = true
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            if let barcodeDetector = self.barcodeDetector{
                let visionImage = VisionImage(buffer: sampleBuffer)
                barcodeDetector.detect(in: visionImage) { result, error in
                    if error != nil{
                        print("barcode scanner error", error?.localizedDescription)
                    }else{
                        for barcode in result! {
                            let data = barcode.rawValue
                            print("barcode value",data)
                            self.invoiceNumber = data!
                                self.session.stopRunning()
                                self.scannerAnimationView.isHidden = true
                            self.flags = "scanned"
                            DispatchQueue.main.asyncAfter(deadline: .now()+4.0, execute: {
                                self.goToUploadCode()
                                 })
//                            self.invoiceNumberCheckApi(invoiceNumber: self.invoiceNumber)
                            self.startLoading()
                                
//                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func goToUploadCode(){
        self.timmer.invalidate()
        self.stopLoading()
        userDetailsView.isHidden = false
        self.invoiceNumberTF.text = invoiceNumber
        self.quantityTF.text = "1"
        claimDetailsView.isHidden = false
        scanBarcodeView.isHidden = true
        uploadCodeLbl.backgroundColor = primaryColor
        uploadCodeLbl.textColor = .white
        scanCodeLbl.backgroundColor = .white
        scanCodeLbl.textColor = .black
        cancelBtn.isHidden = false
        cancelBtnView.isHidden = false
    }
    
    
    func reStartScan(){
        DispatchQueue.main.asyncAfter(deadline: .now()+4.0, execute: {
            self.scannerAnimationView.isHidden = false
            self.stopLoading()
            self.session.startRunning()
             })
    }
    
    func invoiceNumberCheckApi(invoiceNumber: String){
        let parameter : [String : Any] = [
                "ActionType": 168,
                "RoleIDs": invoiceNumber
        ]
        
        self.VM.invoiceNumberValidationApi(parameter: parameter)
    }
    
    func productValidationApi(productId: Int){
        
        let parameter : [String : Any] = [
        
                "ActionType": 169,
                "RoleIDs": "\(productId)" ,   // SEND PRODUCT CODE IN THIS TAGS
                "HelpTopicID": loyaltyId // SEND LOYALTY PROGRAM ID HERE
        ]
        self.VM.productValidationApi(parameter: parameter)
    }
    
    
    func invoiceSalesReturnValidation(){
        let parameter : [String : Any] = [
            
                "ActionType": 170,
                "RoleIDs": invoiceNumberTF.text ?? "",  // SEND INVOIVE NUMBER HERE
                "MobilePrefix": productNameTF.text ?? "" // SEND PRODUCTNAME HERE
             
        ]
        self.VM.claimSubmissionApi(parameter: parameter)
    }
    
    func claimSubmission_Api(){
        let parameter : [String : Any] = [
            "ActorId": userId,
            "LoyaltyId": loyaltyId,
            "InvoiceNumber": invoiceNumberTF.text ?? "",
            "ProductCode": productNameTF.text ?? "",
            "SellingPrice": "",
            "LoyaltyProgramId": 6,
            "VoucherImagePath": "",
            "Domain": "Hoya",
            "ClaimingQuantity": quantityTF.text ?? "0"
        ]
        self.VM.claimSubmissionApi(parameter: parameter)
    }
    
    func checkInvoiceAndProductStatus(){
        let parameter : [String : Any] = [
            "InvoiceNo":invoiceNumberTF.text ?? "",
            "LenDesign": productNameTF.text ?? "",
            "Quantity": quantityTF.text ?? ""
        ]
        self.VM.checkInvAndProductNameValidationApi(paramters: parameter)
    }
}
