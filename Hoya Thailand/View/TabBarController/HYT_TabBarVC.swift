//
//  HYT_TabBarVC.swift
//  Hoya Thailand
//
//  Created by syed on 15/02/23.
//

import UIKit
import LanguageManager_iOS

class HYT_TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.items![0].title = "Home".localiz()
        tabBarController?.tabBar.items![1].title = "Support".localiz()
        tabBarController?.tabBar.items![2].title = "Profile".localiz()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if self.selectedIndex == 0 {
            let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
            rootView.popToRootViewController(animated: false)
//            self.tabBarController?.selectedIndex = selectedIndex
        }else if self.selectedIndex == 1{
//            let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
//            rootView.popToRootViewController(animated: false)
            self.tabBarController?.selectedIndex = selectedIndex
        }else if self.selectedIndex == 2{
//            let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
//            rootView.popToRootViewController(animated: false)
            self.tabBarController?.selectedIndex = selectedIndex
        }
    }
    
    
}
