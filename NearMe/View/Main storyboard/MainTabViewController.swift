//
//  MainTabViewController.swift
//  NearMe
//
//  Created by MedAmine on 12/7/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    static let MAP_VC_INDEX = 0
    static let NEAR_ME_VC_INDEX = 0
    
    static var ref: MainTabViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainTabViewController.ref = self
        
        PlacesController.shared.start()
    }

}
