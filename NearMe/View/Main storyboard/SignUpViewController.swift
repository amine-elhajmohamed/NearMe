//
//  SignUpViewController.swift
//  NearMe
//
//  Created by MedAmine on 12/6/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var btnSignUp: LoadingButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRetypePassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    //MARK:- View configurations
    
    private func configureView(){
        btnSignUp.isExclusiveTouch = true
        btnSignIn.isExclusiveTouch = true
        
        lblError.text = ""
    }
    
    /**
     Enable or disable the elemnts in the view.
     The elements in the view are only the buttons and text fields
     */
    private func enableViewElements(enable: Bool){
        txtEmail.isEnabled = enable
        txtPassword.isEnabled = enable
        txtRetypePassword.isEnabled = enable
        
        btnSignUp.isEnabled = enable
        btnSignIn.isEnabled = enable
    }
    
    //MARK:- Actions
    
    private func attemptCreateNewAccount(){
        guard let email = txtEmail.text, !email.isEmpty else {
            lblError.text = "Please enter an email address"
            txtEmail.becomeFirstResponder()
            return
        }
        
        guard StringUtils.verifyEmailFormat(email: email) else {
            lblError.text = "Email incorrect"
            txtEmail.becomeFirstResponder()
            return
        }
        
        guard let password = txtPassword.text, !password.isEmpty else {
            lblError.text = "Please enter a password"
            txtPassword.becomeFirstResponder()
            return
        }
        
        guard StringUtils.verifyPasswordFormat(password: password) else {
            lblError.text = "Password should be 8 characters or more"
            txtPassword.becomeFirstResponder()
            return
        }
        
        guard let verifyPassword = txtRetypePassword.text, !verifyPassword.isEmpty else {
            lblError.text = "Please retype your password"
            txtRetypePassword.becomeFirstResponder()
            return
        }
        
        
        guard password == verifyPassword else {
            lblError.text = "Passwords not match"
            txtRetypePassword.becomeFirstResponder()
            return
        }
        
        view.endEditing(true)
        enableViewElements(enable: false)
        btnSignUp.startAnimating()
        
        AccountController.shared.createNewAccount(email: email, password: password) { [unowned self] (result: SignUpResult) in
            self.btnSignUp.stopAnimating {
                self.enableViewElements(enable: true)
                
                switch result {
                case .success:
                    if let mainNavVC = self.navigationController as? MainNavigationViewController {
                        mainNavVC.presentMainView(animated: true)
                    }
                case .emailInUse:
                    self.lblError.text = "This email is already in use"
                    self.txtEmail.becomeFirstResponder()
                case .networkError:
                    SVProgressHUD.showError(withStatus: "No internet connection\n\nPlease check your internet connection and try again.")
                case .unknownError:
                    SVProgressHUD.showError(withStatus: "An unknown error occurred, please try again later.")
                }
            }
        }
    }

    @IBAction func btnClicked(_ sender: UIButton) {
        switch sender {
        case btnSignUp:
            attemptCreateNewAccount()
        case btnSignIn:
            navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    
    @IBAction func txtChanged(_ sender: UITextField) {
        if sender == txtEmail || sender == txtPassword || sender == txtRetypePassword {
            lblError.text = ""
        }
    }
}
