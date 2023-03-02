//
//  HYT_DatePickerVC.swift
//  Hoya Thailand
//
//  Created by syed on 21/02/23.
//

import UIKit

protocol DatePickerDelegate{
    func didTappedFromDate(date: String)
    func didTappedToDate(date: String)
    func didTappedDOB(date:String)
    func didTappedDOA(date:String)
}

class HYT_DatePickerVC: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    var date = String()
    var flags: String = ""
    var delegate: DatePickerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        datePickerView.datePickerMode = UIDatePicker.Mode.date
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
        datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
    }
    
    @IBAction func didTappedOkBtn(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.string(from: datePickerView.date)
        print(date)
        switch flags{
        case "FromDate":
            delegate?.didTappedFromDate(date: date)
        case "ToDate":
            delegate?.didTappedToDate(date: date)
        case "DOB":
            delegate?.didTappedDOB(date: date)
        case "DOA":
            delegate?.didTappedDOA(date: date)
        default: print("send valid flags")
        }
        dismiss(animated: true)
    }
    
    @IBAction func didTappedCancelBTn(_ sender: UIButton) {
//        switch flags{
//        case "FromDate":
//            delegate?.didTappedFromDate(date: "")
//        case "ToDate":
//            delegate?.didTappedToDate(date: "")
//        default: print("send valid flags")
//        }
        dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
    
}
