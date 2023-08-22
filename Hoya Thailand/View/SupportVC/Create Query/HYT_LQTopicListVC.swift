//
//  HYT_LQTopicListVC.swift
//  Hoya Thailand
//
//  Created by syed on 14/02/23.
//

import UIKit
import LanguageManager_iOS

protocol TopicListDelegate{
    func topicName(item : HYT_LQTopicListVC)
}
class HYT_LQTopicListVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var topicListTableview: UITableView!
    @IBOutlet weak var topicListDescriptionLbl: UILabel!
    var topicName = ""
    var selectTopicId = 0
    var flags = 0
    var VM = HYT_HelptopicVM()
    
    var topicList : [TopicList] = [TopicList(topicName: "Enrolment Related", topicImage: "user1", helptoicID: 3),
                                   TopicList(topicName: "Redemption Related", topicImage: "guarantee", helptoicID: 7 ),
                                   TopicList(topicName: "Unable to use mobile app", topicImage: "mobile-development", helptoicID: 9),
                                   TopicList(topicName: "Unable to raise purchase claim", topicImage: "error", helptoicID: 1),//mark
                                   TopicList(topicName: "Complaints", topicImage: "cyber-security", helptoicID: 13),
                                   TopicList(topicName: "Point Related", topicImage: "cancel", helptoicID: 1),//mark
                                   TopicList(topicName: "Product Complaints", topicImage: "return", helptoicID: 12),//mark
                                   TopicList(topicName: "Feedback", topicImage: "feedback", helptoicID: 14),
                                   TopicList(topicName: "Information about program", topicImage: "barcode", helptoicID: 11)
    ]
    var delegate : TopicListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        topicListTableview.delegate = self
        topicListTableview.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if flags == 0{
            helpTopicList_Api()

//        }
            }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        if topicName != ""{
//            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_CreateQueryVC") as? HYT_CreateQueryVC
//            
//            navigationController?.pushViewController(vc!, animated: true)
//        }
//    }
    
    @IBAction func didTappedCloseBtn(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    
    
    
    //MARK: - getHelpTopicList_Api
        
        func helpTopicList_Api(){
            let parameter : [String : Any] = [
                    "ActionType": "4",
                    "ActorId": "\(self.userId)",
                    "IsActive": "true"
            ]
            self.VM.getHelpTopicList_Api(parameter: parameter)
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if flags == 0{
            return self.VM.helpTopicList.count
        }else{
            return topicList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_LQTopicListTVCell", for: indexPath) as! HYT_LQTopicListTVCell
        if flags == 0{
            cell.topicNameLbl.text = self.VM.helpTopicList[indexPath.row].helpTopicName
            cell.topicLogo.isHidden = true
        }else{
            cell.topicLogo.isHidden = false
            cell.topicNameLbl.text = self.topicList[indexPath.row].topicName
            cell.topicLogo.image = UIImage(named: topicList[indexPath.row].topicImage)
        }
        
//        cell.topicLogo.isHidden = true
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if flags == 0{
            topicName = self.VM.helpTopicList[indexPath.row].helpTopicName ?? ""
            selectTopicId = self.VM.helpTopicList[indexPath.row].helpTopicId ?? 0
            
            
        }else{
//            topicName = self.topicList[indexPath.row].topicName
            selectTopicId = self.topicList[indexPath.row].helptoicID
            let filterArray = self.VM.helpTopicList.filter{$0.helpTopicId == selectTopicId}
            if filterArray.count > 0 {
                topicName = filterArray[0].helpTopicName ?? "queryTopic_toast_message".localiz()
                selectTopicId = filterArray[0].helpTopicId ?? 0
            }else{
                topicName = "queryTopic_toast_message".localiz()
                selectTopicId = 0
            }
        }
        
        delegate?.topicName(item: self)
        dismiss(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view{
                    dismiss(animated: true)
        }
    }
    
}


struct TopicList{
    let topicName : String
    let topicImage : String
    let helptoicID : Int
}
