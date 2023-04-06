//
//  HYT_MyStaffVC.swift
//  Hoya Thailand
//
//  Created by syed on 10/02/23.
//

import UIKit
import LanguageManager_iOS

class HYT_MyStaffVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var emptyMessageLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var myStaffTableView: UITableView!
    let activeColor = #colorLiteral(red: 0.05882352941, green: 0.7137254902, blue: 0.03529411765, alpha: 1)
    let inActiveColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.8965411543)
    var VM = HYT_MyStaffVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        myStaffTableView.delegate = self
        myStaffTableView.dataSource = self
        emptyMessageLbl.isHidden = true
        localization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myStaffListing_Api()
    }
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func myStaffListing_Api(){
        let parameter : [String : Any] = [
                "ActionType": 2,
                "CustomerId": userId//customerTypeID
                ]
        self.VM.myStaffListing_Api(parameter: parameter)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.VM.myStaffList.count == 0{
            emptyMessageLbl.isHidden = false
        }else{
            emptyMessageLbl.isHidden = true
        }
        return self.VM.myStaffList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_MyStaffTVCell", for: indexPath) as! HYT_MyStaffTVCell
        cell.selectionStyle = .none
        cell.pointsLbl.text = "\(self.VM.myStaffList[indexPath.row].customerAvalialbePointBalance ?? 0)"
        cell.dateLbl.text = self.VM.myStaffList[indexPath.row].customerEnrolledDate
        cell.membershipIdLbl.text = self.VM.myStaffList[indexPath.row].customerUserName
        cell.designationLbl.text = self.VM.myStaffList[indexPath.row].sE_Role
        cell.staffNameLbl.text = self.VM.myStaffList[indexPath.row].customerFirstName
        if self.VM.myStaffList[indexPath.row].status == 1{
            cell.statusLbl.text = "Active"
            cell.statusLbl.textColor = activeColor
        }else if self.VM.myStaffList[indexPath.row].status == 0{
            cell.statusLbl.text = "Inactive"
            cell.statusLbl.textColor = inActiveColor
        }
        return cell
    }
    
    private func localization(){
        titleLbl.text = "mystaff".localiz()
    }
}
