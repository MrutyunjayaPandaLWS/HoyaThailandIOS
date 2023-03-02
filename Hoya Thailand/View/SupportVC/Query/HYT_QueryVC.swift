//
//  HYT_QueryVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit

class HYT_QueryVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,TopicListDelegate, FilterProtocolDelegate {
    func didTappedFilterBtn(item: HYT_FilterVC) {
        fromDate = item.fromDate
        toDate = item.toDate
        programId = "\(item.statusId)"
        getQueryList_Api()
    }
    
 
    func topicName(item: HYT_LQTopicListVC) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_CreateQueryVC") as? HYT_CreateQueryVC
        vc?.queryName = item.topicName
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        queryTableView.delegate = self
        queryTableView.dataSource = self
        emptyMessage.isHidden = true
        backBtnWidth.constant = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getQueryList_Api()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fromDate = ""
        toDate = ""
        programId = ""
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
    
    @IBAction func didTappedNewQueryBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_CreateQueryVC") as? HYT_CreateQueryVC
        navigationController?.pushViewController(vc!, animated: true)
        
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
        self.VM.getQueryList(parameter: parameter)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VM.queryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_QueryTVCell", for: indexPath) as! HYT_QueryTVCell
        cell.selectionStyle = .none
        cell.queryRefNoLbl.text = self.VM.queryList[indexPath.row].customerTicketRefNo
        cell.queryDateLbl.text = "\(self.VM.queryList[indexPath.row].jCreatedDate?.prefix(10) ?? "")"
        cell.timeLbl.text = "\(self.VM.queryList[indexPath.row].jCreatedDate?.suffix(8) ?? "")"
        cell.queryStatusLbl.text = self.VM.queryList[indexPath.row].ticketStatus
        cell.querySummeryLbl.text = self.VM.queryList[indexPath.row].queryDetails
        if self.VM.queryList[indexPath.row].ticketStatus == "Pending"{
            cell.statusView.backgroundColor = pendingStatusColor
        }else if self.VM.queryList[indexPath.row].ticketStatus == "Resolved"{
            cell.statusView.backgroundColor = approvedBgColor
        }else if self.VM.queryList[indexPath.row].ticketStatus == "Closed"{
            cell.statusView.backgroundColor = cancelBgColor
        }else{
            cell.statusView.backgroundColor = pendingStatusColor
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

}
