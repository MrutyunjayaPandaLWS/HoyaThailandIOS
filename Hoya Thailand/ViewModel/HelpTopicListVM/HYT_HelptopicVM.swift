//
//  HYT_HelptopicVM.swift
//  Hoya Thailand
//
//  Created by syed on 25/02/23.
//

import Foundation


class HYT_HelptopicVM{
    weak var VC: HYT_LQTopicListVC?
    var helpTopicList = [ObjHelpTopicList]()
    var requestAPIs = RestAPI_Requests()
    
    func getHelpTopicList_Api(parameter: JSON){
        self.helpTopicList.removeAll()
        self.VC?.startLoading()
        requestAPIs.getHelpTopicList(parameters: parameter) { result, error in
            if error == nil{
                if result != nil{
                    self.helpTopicList = result?.objHelpTopicList ?? []
                    DispatchQueue.main.async {
                        if result?.objHelpTopicList?.count != 0{
                            self.VC?.topicListTableview.reloadData()
                            self.VC?.stopLoading()
                            
                        }else{
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
                    print("salesRepresentativeAPi error",error?.localizedDescription)
                }
            }
        }
    }
}
