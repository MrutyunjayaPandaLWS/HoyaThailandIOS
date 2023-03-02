//
//  HYT_OffersVC.swift
//  Hoya Thailand
//
//  Created by syed on 11/02/23.
//

import UIKit

class HYT_OffersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var offersTableView: UITableView!
    @IBOutlet weak var offersTitleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        offersTableView.delegate = self
        offersTableView.dataSource = self
        emptyMessage.isHidden = true
        
    }
    
    @IBAction func didTappedBackBtn(_ sender: UIButton) {
    }
    
    
//    MARK: - OFFERS TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HYT_OffersTVCell", for: indexPath) as! HYT_OffersTVCell
        cell.selectionStyle = .none
        return cell
    }
}
