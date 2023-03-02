//
//  HYT_LQTopicListVC.swift
//  Hoya Thailand
//
//  Created by syed on 14/02/23.
//

import UIKit
protocol TopicListDelegate{
    func topicName(item : HYT_LQTopicListVC)
}
class HYT_LQTopicListVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var topicListTableview: UITableView!
    @IBOutlet weak var topicListDescriptionLbl: UILabel!
    var topicName = ""
    var selectTopicId = 0
    var VM = HYT_HelptopicVM()
    
    var topicList : [TopicList] = [TopicList(topicName: "Enrolment Related", topicImage: "user1"),
                                   TopicList(topicName: "Redemption Related", topicImage: "guarantee"),
                                   TopicList(topicName: "Unable to use mobile app", topicImage: "mobile-development"),
                                   TopicList(topicName: "Unable to raise purchase claim", topicImage: "error"),
                                   TopicList(topicName: "Complaints", topicImage: "cyber-security"),
                                   TopicList(topicName: "Point Related", topicImage: "cancel"),
                                   TopicList(topicName: "Product Complaints", topicImage: "return"),
                                   TopicList(topicName: "Feedback", topicImage: "feedback"),
                                   TopicList(topicName: "Information about program", topicImage: "barcode"),
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
        helpTopicList_Api()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if topicName != ""{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HYT_CreateQueryVC") as? HYT_CreateQueryVC
            
            navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    @IBAction func didTappedCloseBtn(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    
    
    
    //MARK: - getHelpTopicList_Api
        
        func helpTopicList_Api(){
            let parameter : [String : Any] = [
                    "ActionType": "4",
                    "ActorId": "30",
                    "IsActive": "true"
            ]
            self.VM.getHelpTopicList_Api(parameter: parameter)
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VM.helpTopicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_LQTopicListTVCell", for: indexPath) as! HYT_LQTopicListTVCell
        cell.topicNameLbl.text = self.VM.helpTopicList[indexPath.row].helpTopicName
//        cell.topicLogo.image = UIImage(named: topicList[indexPath.row].topicImage)
        cell.topicLogo.isHidden = true
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        topicName = self.VM.helpTopicList[indexPath.row].helpTopicName ?? ""
        selectTopicId = self.VM.helpTopicList[indexPath.row].helpTopicId ?? 0
        delegate?.topicName(item: self)
        dismiss(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
    
}


struct TopicList{
    let topicName : String
    let topicImage : String
}
