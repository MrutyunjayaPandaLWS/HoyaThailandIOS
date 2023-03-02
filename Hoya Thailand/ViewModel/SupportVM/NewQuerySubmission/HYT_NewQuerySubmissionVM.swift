//
//  HYT_NewQuerySubmissionVM.swift
//  Hoya Thailand
//
//  Created by syed on 27/02/23.
//

import Foundation


class HYT_NewQuerySubmissionVM{
    weak var VC: HYT_CreateQueryVC?
    var requestAPIs = RestAPI_Requests()
    var queryMessage = ""
    func newQuerySubmission(parameter: JSON){
        self.VC?.startLoading()
        requestAPIs.newQuerySubmission(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    if result?.returnMessage?.count != 0{
                        self.queryMessage = result?.returnMessage ?? ""
                        DispatchQueue.main.async {
                            if self.queryMessage.contains("Saved Successfully"){
                                self.VC?.successMessagePopUp(message: "Your query has been submitted successfully")
                                self.VC?.navigationController?.popViewController(animated: true)
                                self.VC?.stopLoading()
                            }else{
                                self.VC?.view.makeToast("query submit failed", duration: 2.0, position: .center)
                                self.VC?.stopLoading()
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.VC?.stopLoading()
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("New Query Submission error",error?.localizedDescription)
                }
            }
        }
    }
}
