//
//  MainNavigationViewController.swift
//  NearMe
//
//  Created by MedAmine on 12/6/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainNavigationViewController: UINavigationController {

    private var isFirstTimeAppearing = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTimeAppearing {
            isFirstTimeAppearing = false
            
            if Auth.auth().currentUser != nil {
                presentMainView(animated: false)
            } else {
                restNavigationControllerViews()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK:- View configuration
    
    func restNavigationControllerViews(){
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") {
            viewControllers = [loginVC]
        }
    }
    
    //MARK:- Actions
    
    func presentMainView(animated: Bool){
        if let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") {
            present(mainVC, animated: animated) { [unowned self] in
                self.restNavigationControllerViews()
            }
        }
    }

}
