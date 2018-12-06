//
//  LoginViewController.swift
//  NearMe
//
//  Created by MedAmine on 12/6/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var btnSignIn: LoadingButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnSignInGoogle: CustomButton!
    @IBOutlet weak var btnSignInFacebook: CustomButton!
    
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    //MARK:- View configurations
    
    private func configureView(){
        btnSignIn.isExclusiveTouch = true
        btnRegister.isExclusiveTouch = true
        btnSignInGoogle.isExclusiveTouch = true
        btnSignInFacebook.isExclusiveTouch = true
        
        lblError.text = ""
    }
    
    /**
     Enable or disable the elemnts in the view.
     The elements in the view are only the buttons and text fields
     */
    private func enableViewElements(enable: Bool){
        txtEmail.isEnabled = enable
        txtPassword.isEnabled = enable
        
        btnSignIn.isEnabled = enable
        btnRegister.isEnabled = enable
        btnSignInGoogle.isEnabled = enable
        btnSignInFacebook.isEnabled = enable
    }
    
    //MARK:- Actions
    
    private func attemptSignInWithEmail(){
        
        guard let email = txtEmail.text, StringUtils.shared.verifyEmailFormat(email: email) else {
            lblError.text = "Please enter a valid email address"
            txtEmail.becomeFirstResponder()
            return
        }

        guard let password = txtPassword.text, !password.isEmpty else {
            lblError.text = "Please enter the password"
            txtPassword.becomeFirstResponder()
            return
        }
        
        view.endEditing(true)
        enableViewElements(enable: false)
        btnSignIn.startAnimating()
        
        AccountController.shared.signIn(email: email, password: password) { [unowned self] (result: SignInResult)  in
            self.btnSignIn.stopAnimating {
                self.enableViewElements(enable: true)
                
                switch result {
                case .success:
                    if let mainNavVC = self.navigationController as? MainNavigationViewController {
                        mainNavVC.presentMainView(animated: true)
                    }
                case .wrongPassword:
                    self.lblError.text = "Wrong password"
                    self.txtPassword.text = ""
                    self.txtPassword.becomeFirstResponder()
                case .emailNotExist:
                    let alertVC = UIAlertController(title: "Account not found", message: "Do you want to create a new account with this email ?", preferredStyle: .alert)
                    
                    alertVC.addAction(UIAlertAction(title: "Create", style: .default, handler: { [unowned self] (_) in
                        if let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpViewController {
                            signInVC.loadViewIfNeeded()
                            signInVC.txtEmail.text = email
                            self.navigationController?.pushViewController(signInVC, animated: true)
                        }
                    }))
                    alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    self.present(alertVC, animated: true, completion: nil)
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
        case btnSignIn:
            attemptSignInWithEmail()
        case btnRegister:
            if let signInVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") {
                navigationController?.pushViewController(signInVC, animated: true)
            }
        case btnSignInGoogle:
            break
        case btnSignInFacebook:
            break
        default:
            break
        }
    }
    
    @IBAction func txtChanged(_ sender: UITextField) {
        if sender == txtEmail || sender == txtPassword {
            lblError.text = ""
        }
    }
    
}
