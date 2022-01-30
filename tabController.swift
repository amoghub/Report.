//
//  tabController.swift
//  Report.
//
//  Created by Amogh Kalyan on 12/1/21.
//

import SwiftUI

class tabController: UITabBarController {
    var lastSavedTab = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //make check for first time user
        
        self.selectedIndex = lastSavedTab.value(forKey: "tab") as! Int
    }
    
    
    // Override selectedViewController for User initiated changes
    override var selectedViewController: UIViewController? {
        didSet {
            tabChangedTo(selectedIndex: selectedIndex)
        }
    }
    // Override selectedIndex
    override var selectedIndex: Int {
        didSet {
            tabChangedTo(selectedIndex: selectedIndex)
        }
    }
    // handle new selection
     func tabChangedTo(selectedIndex: Int) {
         lastSavedTab.setValue(selectedIndex, forKey: "tab")
     }
}
