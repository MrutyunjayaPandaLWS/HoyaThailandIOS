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
import LanguageManager_iOS

class HYT_ClaimDetailsVC: BaseViewController,AVCaptureVideoDataOutputSampleBufferDelegate,CLLocationManagerDelegate, FilterStatusDelegate, SearchableDropDownDelegate,UITextFieldDelegate, InternetCheckDelgate {
    
    func interNetIsON(item: IOS_Internet_Check) {
        getProductList_Api()
    }
    
    func didTappedFilterStatus(item: HYT_DropDownVC) {
        lensDesignNameLbl.text = item.statusName
        lensDesignNameLbl.textColor = .black
        productName = item.statusName
        productCode = "\(item.statusId)"
    }
    func selectedProductName(item: SelectDealerDropDownVC) {
        lensDesignNameLbl.text = item.selectedStatusName
        lensDesignNameLbl.textColor = .black
        productName = item.selectedStatusName
        productCode = "\(item.selectedStatusID)"
    }

    @IBOutlet weak var dropDownBtn: UIButton!
    
    @IBOutlet weak var lensDesignNameLbl: UILabel!
    @IBOutlet weak var shadowView: UIImageView!
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
    var quantity = "1"
    var scanCodeStatus = -1
    var productCodeStatus = -1
    var salesReturnStatus = -1
    var productName = ""
    var productCode = ""
    var productAndInvoiceValidation = "false"
    var flags = ""
    var timmer = Timer()
    var placeHolderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        lottieAnimation(animationView: scannerAnimationView)
        scanBarcodeView.isHidden = false
        shadowView.isHidden = false
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
        quantityTF.text = "2"
        quantityTF.isEnabled =  false
        invoiceNumberTF.delegate = self
        localization()
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_Internet_Check") as! IOS_Internet_Check
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                vc.delegate = self
                self.present(vc, animated: true)
            }
        }else{
            getProductList_Api()
        }
//        getProductList_Api()
        scannerSetup()
    }
    
    private func localization(){
        viewTitle.text = "claim".localiz()
        claimDetailsLbl.text = "Claim Details".localiz()
        invoiceNumberLbl.text = "invoiceNumer".localiz()
        productNameLbl.text = "Lens Design".localiz()
        quantityLbl.text = "Quantity".localiz()
        submitBtn.setTitle("submit".localiz(), for: .normal)
        cancelBtn.setTitle("Cancel".localiz(), for: .normal)
        uploadCodeLbl.text = "Upload Code".localiz()
        scanCodeLbl.text = "Scan_Code".localiz()
        validityDateTitle.text = "Validity until".localiz()
    }
    
    @IBAction func didTappedScanCodeBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.session.startRunning()
        }
        shadowView.isHidden = false
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
            self.view.makeToast("Enter your invoice number".localiz(), duration: 2.0, position: .center)
        }else if lensDesignNameLbl.text == "Select Lens Design"{
            self.view.makeToast("Select the product name".localiz(), duration: 2.0, position: .center)
        }else if quantityTF.text?.count == 0{
            self.view.makeToast("Enter a quantity".localiz(), duration: 2.0, position: .center)
        }
//        else if scanCodeStatus == -1{
//            self.view.makeToast("Invoice number already exist", duration: 2.0, position: .center)
//        }else if productCodeStatus == -1{
//            self.view.makeToast("Summitted Len Design is not available", duration: 2.0, position: .center)
//        }else if salesReturnStatus == -1{
//            self.view.makeToast("Invalid claim request", duration: 2.0, position: .center)
//        }else if productAndInvoiceValidation == "false"{
//            self.view.makeToast("Invalid claim request", duration: 2.0, position: .center)
//        }
        else{
//            invoiceNumberCheckApi(invoiceNumber: invoiceNumberTF.text ?? "")
            productValidationApi(productId: productCode)
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
        shadowView.isHidden = true
        uploadCodeLbl.backgroundColor = primaryColor
        uploadCodeLbl.textColor = .white
        scanCodeLbl.backgroundColor = .white
        scanCodeLbl.textColor = .black
//        cancelBtn.isHidden = true
//        cancelBtnView.isHidden = true
//        if claimDetailsView.isHidden == true{
            invoiceNumber = ""
            productName = ""
            self.invoiceNumberTF.text = ""
            self.invoiceNumberTF.isEnabled = true
            self.lensDesignNameLbl.text = "Select Lens Design"
            self.lensDesignNameLbl.textColor = placeHolderColor
            dropDownBtn.isEnabled = true
//        }
        
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
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectDealerDropDownVC") as? SelectDealerDropDownVC
            vc?.modalPresentationStyle = .overFullScreen
            vc?.modalTransitionStyle = .crossDissolve
//            vc?.flags = "productList"
            vc?.progrmaId = promotionData?.programId ?? 0
            vc?.delegate = self
            present(vc!, animated: true)
//        }

    }
    
    
    
}

extension HYT_ClaimDetailsVC{
    
    func authorizelocationstates(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentlocation = locationManager.location
            print(currentlocation ?? "")
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
                let alertVC = UIAlertController(title: "Hoya Application need Camera permission for Scanning Codes".localiz(), message: "Allow Camera Access".localiz(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Allow".localiz(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
//                    UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    self.startLiveVideo()
                }
                let cancelAction = UIAlertAction(title: "DisAllow".localiz(), style: UIAlertAction.Style.cancel) {
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
                        print("barcode scanner error", error?.localizedDescription ?? "")
                    }else{
                        for barcode in result! {
                            let data = barcode.rawValue
                            print("barcode value",data ?? "")
                            if data?.contains(",") == true{
                                let scanValue = data?.split(separator: ",")
                                if (scanValue?.count ?? 0) >= 2{
                                    var productData = String(scanValue?[1] ?? "")
                                    if productData.first == " "{
                                       productData = "\(productData.dropFirst())"
                                    }
                                        var filterProduct = self.VM.promotionProductList.filter { $0.productName == productData }
                                    if filterProduct.count == 0{
                                        filterProduct = self.VM.promotionProductList.filter { ($0.productCode ?? "") == productData }
                                    }
                                        if filterProduct.count != 0{
                                            self.startLoading()
                                            self.session.stopRunning()
                                            self.invoiceNumber = String(scanValue?[0] ?? "")
//                                            self.quantity = String(scanValue?[2] ?? "")
                                            self.productName = filterProduct[0].productName ?? ""
                                            self.scannerAnimationView.isHidden = true
                                            self.flags = "scanned"
                                            self.productCode = filterProduct[0].productCode ?? ""
                                            DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                                                self.stopLoading()
                                                self.goToUploadCode()
                                                 })
                                        }else{
                                            
                                            self.view.makeToast("lens design name is not available".localiz(),duration: 2.0,position: .center)
                                            DispatchQueue.main.async {
                                                self.session.startRunning()
                                            }
                                        }
                                    
                                }else{
                                    self.view.makeToast("Scan a valid QR Code".localiz(),duration: 2.0,position: .center)
                                }
                            }else{
                                self.view.makeToast("Scan a valid QR Code".localiz(),duration: 2.0,position: .center)
                            }
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
        self.lensDesignNameLbl.text = productName
        self.lensDesignNameLbl.textColor = .black
        dropDownBtn.isEnabled = false
        self.invoiceNumberTF.isEnabled = false
        self.quantityTF.text = "2"
        claimDetailsView.isHidden = false
        scanBarcodeView.isHidden = true
        shadowView.isHidden = true
        uploadCodeLbl.backgroundColor = primaryColor
        uploadCodeLbl.textColor = .white
        scanCodeLbl.backgroundColor = .white
        scanCodeLbl.textColor = .black
        cancelBtn.isHidden = false
        cancelBtnView.isHidden = false
    }
    
    
    func reStartScan(){
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
            self.scannerAnimationView.isHidden = false
            self.stopLoading()
            self.session.startRunning()
             })
    }
    
//    MARK: - LWS - INVOICE NUMBER VALIDATION API
    func invoiceNumberCheckApi(invoiceNumber: String){
        let parameter : [String : Any] = [
                "ActionType": 168,
                "RoleIDs": invoiceNumber
        ]
        print(parameter,"invoiceNumberCheckApi")
        self.VM.invoiceNumberValidationApi(parameter: parameter)
    }
    
    
//    MARK: LWS - PRODUCT VALIDATION API
    func productValidationApi(productId: String){
        
        let parameter : [String : Any] = [
        
                "ActionType": 169,
                "RoleIDs": "\(productId)" ,   // SEND PRODUCT CODE IN THIS TAGS
                "HelpTopicID": promotionData?.programId ?? 0// SEND LOYALTY PROGRAM ID HERE
        ]
        print(parameter,"productValidationApi")
        self.VM.productValidationApi(parameter: parameter)
    }
    
//    MARK: - COMBINATION VALIDATION API
    func combineValidationApi(){
        let parameter : [String : Any] = [
            
                "ActionType": 170,
                "RoleIDs": invoiceNumberTF.text ?? "",  // SEND INVOIVE NUMBER HERE
                "MobilePrefix": productCode // SEND PRODUCTNAME HERE
             
        ]
        print(parameter,"combineValidationApi")
        self.VM.combine_Inv_Pro_Validation(parameter: parameter)
    }
    
//    MARK: - CLAIM SUBMISSION API
    func claimSubmission_Api(){
        let parameter : [String : Any] = [
            "ActorId": userId,
            "LoyaltyId": loyaltyId,
            "InvoiceNumber": invoiceNumberTF.text ?? "",
            "ProductCode": productCode,//lensDesignNameLbl.text ?? "",
            "SellingPrice": 1,
            "LoyaltyProgramId": promotionData?.programId ?? 0,
            "VoucherImagePath": "",
            "Domain": "Hoya",
            "ClaimingQuantity": quantityTF.text ?? "0"
        ]
        print(parameter,"claimSubmission_Api")
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_Internet_Check") as! IOS_Internet_Check
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }else{
            self.VM.claimSubmissionApi(parameter: parameter)
        }
//        self.VM.claimSubmissionApi(parameter: parameter)
    }
    
//    MARK: - HOYA VALIDATION
    func hoyaValidationApi(){
        let parameter : [String : Any] = [
            "Country": "Thailand",
            "InvoiceNo":invoiceNumberTF.text ?? "",
            "LenDesign": lensDesignNameLbl.text ?? "",
            "Quantity": quantityTF.text ?? ""
        ]
        print(parameter,"hoyaValidationApi")
        self.VM.hoyaValidationApi(paramters: parameter)
    }
    
//    MARK: - PRODUCT LISTING API
    func getProductList_Api(){
        let parameter : [String : Any] = [
                "ActorId":userId,
                 "SearchText": "",
                "LoyaltyProgramId": promotionData?.programId ?? 0,
                "ProductDetails":[
                    "ActionType": 20
                ]
        ]
        print(parameter,"getProductList_Api")
        
        self.VM.productListApi(parameter: parameter)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.invoiceNumberTF.text = self.invoiceNumberTF.text?.uppercased()
        return true
    }
}
