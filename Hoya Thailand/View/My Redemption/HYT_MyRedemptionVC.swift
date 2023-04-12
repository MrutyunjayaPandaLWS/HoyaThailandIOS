//
//  HYT_MyRedemptionVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import LanguageManager_iOS

class HYT_MyRedemptionVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, FilterProtocolDelegate,myRedeemptionDelegate {
    func downloadVoucher(item: HYT_MyRedemptionTVCell) {
//        downloadImage(url: item.downloadVoucher, productName: item.productName)
        downloadImage1(url: item.downloadVoucher, productName: item.productName)
    }
    
    func didTappedFilterBtn(item: HYT_FilterVC) {
        fromDate = item.fromDate
        toDate = item.toDate
        statusId = "\(item.statusId)"
        myRedeemptionList_Api()
    }
    

    @IBOutlet weak var emptyMessageLbl: UILabel!
    @IBOutlet weak var myRedeemptionTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    var VM = HYT_MyRedemptionVM()
    var fromDate = ""
    var toDate = ""
    var statusId = "-1"
    var startIndex = 1
    var noOfElement = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        myRedeemptionTableView.delegate = self
        myRedeemptionTableView.dataSource = self
        emptyMessageLbl.isHidden = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myRedeemptionList_Api()
        localization()
    }
    
    @IBAction func didTappedFilterBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_FilterVC") as? HYT_FilterVC
        vc?.modalPresentationStyle = .overFullScreen
        vc?.modalTransitionStyle = .crossDissolve
        vc?.flags = "queryStatus"
        vc?.delegate = self
        present(vc!, animated: true)
    }
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
        if myRedeemptionData.redemptionStatus == 1 {
            cell.downloadVoucherViewHeight.constant = 60
            cell.statusLbl.text = "Approved"
            cell.statusLbl.textColor = approvedTextColor
            cell.statusLbl.backgroundColor = approvedBgColor
            cell.downloadVoucher = myRedeemptionData.productImage ?? ""
        }else if myRedeemptionData.redemptionStatus == 0{
            cell.downloadVoucherViewHeight.constant = 0
            cell.statusLbl.text = "Pending"
            cell.statusLbl.textColor = pendingStatusColor
            cell.statusLbl.backgroundColor = pendingBGColor
        }else if myRedeemptionData.redemptionStatus == 5{
            cell.downloadVoucherViewHeight.constant = 0
            cell.statusLbl.text = "Reject"
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
                    startIndex += 1
                    myRedeemptionList_Api()
                }else if noOfElement > 10{
                    startIndex += 1
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
    }
 
    func downloadImage(url: String,productName: String){
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        if let url = URL(string: url) {
            URLSession.shared.downloadTask(with: url) { location, response, error in
                guard let location = location else {
                    print("download error:", error ?? "")
                    return
                }
                // move the downloaded file from the temporary location url to your app documents directory
                do {
                    try FileManager.default.moveItem(at: location, to: documents.appendingPathComponent(productName))
                    print("downloaded")
                } catch {
                    print(error)
                }
            }.resume()
        }
    }
    
    func downloadImage1(url: String,productName: String){
        if url.count != 0{
            self.startLoading()
            let imagestring = String(url)

            DispatchQueue.main.async {
                    if let url = URL(string: imagestring),
                    let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data) {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    self.view.makeToast("Voucher is downloaded",duration: 2.0,position: .center)
                        self.stopLoading()
                }
            }
        }else{
            self.view.makeToast("Voucher file isn't available",duration: 2.0,position: .center)
        }

    }
    
}
