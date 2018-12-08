//
//  MainTabViewController.swift
//  NearMe
//
//  Created by MedAmine on 12/7/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlacesController.shared.start()
    }

}
