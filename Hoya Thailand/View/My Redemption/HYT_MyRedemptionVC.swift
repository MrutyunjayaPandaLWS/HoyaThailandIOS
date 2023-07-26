//
//  HYT_MyRedemptionVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import LanguageManager_iOS
import WebKit
import SafariServices
import PDFKit


class HYT_MyRedemptionVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, FilterProtocolDelegate,myRedeemptionDelegate {
    func didTappedResetFilterBtn(item: HYT_FilterVC) {
        fromDate = ""
        toDate = ""
        statusId = "-1"
        statusName = ""
        startIndex = 0
        noOfElement = 0
        self.VM.myRedeemptionList.removeAll()
        myRedeemptionList_Api()
    }
    
    func downloadVoucher(item: HYT_MyRedemptionTVCell) {
        //        downloadImage(url: item.downloadVoucher, productName: item.productName)
        //        downloadImage1(url: item.downloadVoucher, productName: item.productName)
        self.downloadVoucherShadowView.isHidden =  false
        let request =  URLRequest(url: URL(string: item.pdfLink)!)
        self.voucherDetailsWebview.load(request)
        self.pdfLink = item.pdfLink ?? ""
        self.pdfFileName =  item.productName
    }
    
    func didTappedFilterBtn(item: HYT_FilterVC) {
        fromDate = item.fromDate
        toDate = item.toDate
        statusId = item.statusId
        statusName = item.statusName
        startIndex = 0
        noOfElement = 0
        self.VM.myRedeemptionList.removeAll()
        myRedeemptionList_Api()
    }
    
    
    @IBOutlet weak var voucherDetailsWebview: WKWebView!
    @IBOutlet weak var downloadVoucherShadowView: UIView!
    @IBOutlet weak var emptyMessageLbl: UILabel!
    @IBOutlet weak var myRedeemptionTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    var VM = HYT_MyRedemptionVM()
    var fromDate = ""
    var toDate = ""
    var statusName = ""
    var statusId = "-1"
    var startIndex = 1
    var noOfElement = 0
    var pdfLink = ""
    var pdfFileName = "Voucher"
    let renderer = UIPrintPageRenderer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        myRedeemptionTableView.delegate = self
        myRedeemptionTableView.dataSource = self
        emptyMessageLbl.isHidden = true
        self.myRedeemptionTableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 50,right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.VM.myRedeemptionList.removeAll()
        self.downloadVoucherShadowView.isHidden = true
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_Internet_Check") as! IOS_Internet_Check
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }else{
            myRedeemptionList_Api()
        }
//        myRedeemptionList_Api()
        localization()
    }
    
    @IBAction func didTappedFilterBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_FilterVC") as? HYT_FilterVC
        vc?.modalPresentationStyle = .overFullScreen
        vc?.modalTransitionStyle = .crossDissolve
        vc?.flags = "myRedeemption"
        vc?.fromDate = fromDate
        vc?.toDate = toDate
        vc?.statusId = statusId
        vc?.statusName = statusName
        vc?.delegate = self
        present(vc!, animated: true)
    }
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedVoucherDownloadBtn(_ sender: Any) {
        if pdfLink != nil && pdfLink != ""{
            convertandSavePdfToDevice(name: pdfFileName)
        }else{
            self.view.makeToast("Voucher file isn't available",duration: 2.0,position: .center)
        }
    }
    
    func convertandSavePdfToDevice(name: String) {
        self.startLoading()
                //create print formatter object
                let printFormatter = voucherDetailsWebview.viewPrintFormatter()
                // create renderer which renders the print formatter's content on pages
                let renderer = UIPrintPageRenderer()
                renderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)

                // Specify page sizes
                let pageSize = CGSize(width: 595.2, height: 841.8) //set desired sizes

                // Page margines
                let margin = CGFloat(20.0)

                // Set page sizes and margins to the renderer
                renderer.setValue(NSValue(cgRect: CGRect(x: margin, y: margin, width: pageSize.width, height: pageSize.height - margin * 2.0)), forKey: "paperRect")
                renderer.setValue(NSValue(cgRect: CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height)), forKey: "printableRect")

                // Create data object to store pdf data
                let pdfData = NSMutableData()
                // Start a pdf graphics context. This makes it the current drawing context and every drawing command after is captured and turned to pdf data
                UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)

                // Loop through number of pages the renderer says it has and on each iteration it starts a new pdf page
                for i in 0..<renderer.numberOfPages {
                     UIGraphicsBeginPDFPage()
                // draw content of the page
                     renderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
                }
                // Close pdf graphics context
                UIGraphicsEndPDFContext()
                
                
                let filePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(name).pdf")
                try? pdfData.write(to: filePath, options: .atomic)
                let activityViewController = UIActivityViewController(activityItems: [filePath], applicationActivities: [])
        self.stopLoading()
                present(activityViewController, animated: true, completion: nil)
            }
    

    
    @IBAction func didTappedCloseBtn(_ sender: UIButton) {
        self.downloadVoucherShadowView.isHidden =  true
    }
    //  MARK: - MR REDEEMPTION LIST API
    func myRedeemptionList_Api(){
        let parameter : [String : Any] =
        //        [
        //                "ActionType": 52,
        //                "ActorId": self.userId,
        //                "StartIndex": startIndex,
        //                "NoOfRows": "10",
        //                "CustomerTypeID": self.customerTypeID,
        //                "ObjCatalogueDetails": [
        //                    "JFromDate": fromDate,
        //                    "RedemptionTypeId": "-1",
        //                    "SelectedStatus": statusId,
        //                    "JToDate": toDate
        //                ]
        //        ]
        
        [
            "ActionType": 52,
            "ActorId": userId,
            "StartIndex": startIndex,
            "NoOfRows": 10,
            "ObjCatalogueDetails": [
                "CatalogueType": 4,
                "MerchantId": 1,
                "JFromDate": fromDate,
                "JToDate": toDate,
                "RedemptionTypeId": "-1",
                "SelectedStatus": statusId
            ],
            "Vendor":"WOGI"
        ]
        print(parameter,"myRedeemptionList_Api")
        self.VM.myRedeemptionListApi(parameter: parameter)
    }
    
    //    MARK: - MY REDEMPTION TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VM.myRedeemptionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_MyRedemptionTVCell", for: indexPath) as! HYT_MyRedemptionTVCell
        cell.selectionStyle = .none
        var myRedeemptionData = self.VM.myRedeemptionList[indexPath.row]
        if myRedeemptionData.redemptionStatus == 4 {
            cell.downloadVoucherViewHeight.constant = 60
            cell.statusLbl.text = "Deliverd"
            cell.statusLbl.textColor = approvedTextColor
            cell.statusLbl.backgroundColor = approvedBgColor
            cell.downloadVoucher = myRedeemptionData.productImage ?? ""
            cell.pdfLink = myRedeemptionData.pdfLink ?? ""
        }else if myRedeemptionData.redemptionStatus == 0{
            cell.downloadVoucherViewHeight.constant = 0
            cell.statusLbl.text = "Pending"
            cell.statusLbl.textColor = pendingStatusColor
            cell.statusLbl.backgroundColor = pendingBGColor
        }else if myRedeemptionData.redemptionStatus == 3{
            cell.downloadVoucherViewHeight.constant = 0
            cell.statusLbl.text = "Cancelled"
            cell.statusLbl.textColor = cancelTextColor
            cell.statusLbl.backgroundColor = cancelBgColor
        }
        cell.pointsLbl.text = "\(Int(myRedeemptionData.redemptionPoints ?? 0) ) \("points".localiz())"
        let redeemptionDate = myRedeemptionData.jRedemptionDate?.split(separator: " ")
        cell.dateLbl.text = String(redeemptionDate?[0] ?? "-")
        cell.voucherNameLbl.text = myRedeemptionData.productName ?? "-"
        cell.productName = myRedeemptionData.productName ?? "-"
        cell.delegate = self
        return cell
    }
    
    //    Height = 60
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == myRedeemptionTableView{
            if indexPath.row != (self.VM.myRedeemptionList.count - 1){
                if noOfElement == 10{
                    self.startIndex = self.startIndex + 1
                    myRedeemptionList_Api()
                }else if noOfElement > 10{
                    self.startIndex = self.startIndex + 1
                    myRedeemptionList_Api()
                }else if noOfElement < 10{
                    print("no need to reload")
                    return
                }else{
                    print("no more data available")
                    return
                }
            }
        }
    }
    
    private func localization(){
        titleLbl.text = "myredeemption".localiz()
        emptyMessageLbl.text = "No data found!".localiz()
    }
    


    
    func pdfDownload(urlString: String,imageName: String){
        DispatchQueue.main.async {
            let urltoUse = String(urlString).replacingOccurrences(of: " ", with: "%20")
            print(urltoUse)
            let urlString = urltoUse
            let url = URL(string: urlString)
            let fileName = String((url!.lastPathComponent)) as NSString
            // Create destination URL
            let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
            let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
            //Create URL to the source file you want to download
            let fileURL = URL(string: urlString)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            let request = URLRequest(url:fileURL!)
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                    }
                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                        do {
                            //Show UIActivityViewController to save the downloaded file
                            let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                            for indexx in 0..<contents.count {
                                if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                    DispatchQueue.main.async {
                                        let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                                        self.present(activityViewController, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                        catch (let err) {
                            print("error: \(err)")
                        }
                    } catch (let writeError) {
                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    }
                } else {
                    print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
                }
            }
            task.resume()
            self.view.makeToast("PDF has been downloaded successfully", duration: 2.0, position: .bottom)
            self.stopLoading()
        }
    }

}

