//
//  HYT_DatePickerVC.swift
//  Hoya Thailand
//
//  Created by syed on 21/02/23.
//

import UIKit

protocol DateSelectedDelegate{
    func acceptDate(_ vc: HYT_DatePickerVC)
    func declineDate(_ vc: HYT_DatePickerVC)
}

class HYT_DatePickerVC: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    var date = String()
    var flags: String = ""
    var isComeFrom = ""
    var delegate: DateSelectedDelegate!
    var selectedDate = ""
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
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view{
                    dismiss(animated: true)
        }
    }
    
    @IBAction func didTappedOkBtn(_ sender: UIButton) {
        let today = Date() //Jun 21, 2017, 7:18 PM
        let sevenDaysBeforeToday = Calendar.current.date(byAdding: .year, value: -18, to: today)!
        print(sevenDaysBeforeToday)
        if isComeFrom == "DOB"{
            if datePickerView.date > sevenDaysBeforeToday{
                let alert = UIAlertController(title: "", message: "It seems you are less than 18 years of age. You can apply for HOYO membership only if you are 18 years and above", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                selectedDate = formatter.string(from: datePickerView.date)
                self.delegate.acceptDate(self)
                self.dismiss(animated: true, completion: nil)
            }
        }else if isComeFrom == "1"{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            selectedDate = formatter.string(from: datePickerView.date)
            self.delegate.acceptDate(self)
            self.dismiss(animated: true, completion: nil)
        }else if isComeFrom == "2"{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            selectedDate = formatter.string(from: datePickerView.date)
            self.delegate.acceptDate(self)
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func didTappedCancelBTn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    
}
