//
//  MainViewController.swift
//  NearMe
//
//  Created by MedAmine on 12/6/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import GoogleSignIn

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        GIDSignIn.sharedInstance()?.signOut()
        AccountController.shared.logoutCurrentUser { (_) in            
            self.dismiss(animated: true, completion: nil)
        }
    }

}
