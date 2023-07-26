//
//  HYT_QueryVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit
import LanguageManager_iOS

class HYT_QueryVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,TopicListDelegate, FilterProtocolDelegate {
    func didTappedResetFilterBtn(item: HYT_FilterVC) {
        fromDate = ""
        toDate = ""
        programId = ""
        programName = ""
        getQueryList_Api()
    }
    
    func didTappedFilterBtn(item: HYT_FilterVC) {
        fromDate = item.fromDate
        toDate = item.toDate
        programId = item.statusId
        programName = item.statusName
        getQueryList_Api()
    }
    
 
    func topicName(item: HYT_LQTopicListVC) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_CreateQueryVC") as? HYT_CreateQueryVC
        vc?.queryName = item.topicName
        vc?.selectTopicId = item.selectTopicId
        navigationController?.pushViewController(vc!, animated: true)
    }

    @IBOutlet weak var backBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var queryTableView: UITableView!
    @IBOutlet weak var newQueryLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    var VM = HYT_QueryListVM()
    var fromDate = ""
    var toDate = ""
    var programId = ""
    var programName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        queryTableView.delegate = self
        queryTableView.dataSource = self
        emptyMessage.isHidden = true
        backBtnWidth.constant = 0
        localization()
        self.queryTableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 50,right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_Internet_Check") as! IOS_Internet_Check
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }else{
            getQueryList_Api()
        }
        localization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fromDate = ""
        toDate = ""
        programId = ""
        programName = ""
    }

    @IBAction func didTappedFilterBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_FilterVC") as? HYT_FilterVC
        vc?.modalPresentationStyle = .overFullScreen
        vc?.modalTransitionStyle = .crossDissolve
        vc?.flags = "queryStatus"
        vc?.statusId = programId
        vc?.statusName = programName
        vc?.fromDate = fromDate
        vc?.toDate = toDate
        vc?.delegate = self
        present(vc!, animated: true)
    }
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedNewQueryBtn(_ sender: UIButton) {
//        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_CreateQueryVC") as? HYT_CreateQueryVC
//        navigationController?.pushViewController(vc!, animated: true)
        
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_LQTopicListVC") as? HYT_LQTopicListVC
        vc?.modalPresentationStyle = .overFullScreen
        vc?.modalTransitionStyle = .crossDissolve
        vc?.delegate = self
        vc?.flags = 1
        present(vc!, animated: true)
        
    }
    
    func getQueryList_Api(){
        let parameter : [String : Any] = [

                    "ActionType": "1",
                    "ActorId": userId,
                    "HelpTopicID": "-1",
                    "TicketStatusId": programId,
                    "JFromDate": fromDate,
                    "JToDate": toDate,
                    "QueryStatus":""
                
        ]
        print(parameter,"getQueryList_Api")
        self.VM.getQueryList(parameter: parameter)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VM.queryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_QueryTVCell", for: indexPath) as! HYT_QueryTVCell
        cell.selectionStyle = .none
        cell.queryRefNoLbl.text = self.VM.queryList[indexPath.row].customerTicketRefNo ?? "-"
        let queryDate = self.VM.queryList[indexPath.row].jCreatedDate?.split(separator: " ")
        cell.queryDateLbl.text = "\(queryDate?[0] ?? "-")"
        cell.timeLbl.text = "\(queryDate?[1] ?? "-")"
        cell.queryStatusLbl.text = self.VM.queryList[indexPath.row].ticketStatus ?? ""
        cell.querySummeryLbl.text = self.VM.queryList[indexPath.row].queryDetails ?? "-"
        if self.VM.queryList[indexPath.row].ticketStatus == "Pending"{
            cell.statusView.backgroundColor = pendingStatusColor
        }else if self.VM.queryList[indexPath.row].ticketStatus == "Resolved"{
            cell.statusView.backgroundColor = approvedTextColor
        }else if self.VM.queryList[indexPath.row].ticketStatus == "Closed"{
            cell.statusView.backgroundColor = cancelTextColor
        }else{
            cell.statusView.backgroundColor = cancelTextColor
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HR_Chatvc2ViewController") as! HR_Chatvc2ViewController
        vc.CustomerTicketIDchatvc = self.VM.queryList[indexPath.row].customerTicketID ?? 0
        print(vc.CustomerTicketIDchatvc, "CustomerChat ID")
        vc.helptopicid = self.VM.queryList[indexPath.row].helpTopicID ?? 0
        vc.helptopicName = self.VM.queryList[indexPath.row].helpTopic ?? ""
        vc.helptopicdetails = self.VM.queryList[indexPath.row].querySummary ?? ""
        vc.querydetails = self.VM.queryList[indexPath.row].queryDetails ?? ""
        vc.querysummary = self.VM.queryList[indexPath.row].querySummary ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func localization(){
        titleLbl.text = "query".localiz()
        newQueryLbl.text = "newQuery".localiz()
        emptyMessage.text = "No data found!".localiz()
    }
    
}
