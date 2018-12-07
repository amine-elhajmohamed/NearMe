//
//  AccountController.swift
//  NearMe
//
//  Created by MedAmine on 12/6/18.
//  Copyright © 2018 amine. All rights reserved.
//

import Foundation
import FirebaseAuth

class AccountController {
    
    static let shared = AccountController()
    
    func createNewAccount(email: String, password: String, onComplition: @escaping ((SignUpResult)->())){
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult: AuthDataResult?, error: Error?) in
            if authDataResult?.user != nil {
                onComplition(.success)
            } else {
                guard let error = error, let errCode = AuthErrorCode(rawValue: error._code) else {
                    onComplition(.unknownError)
                    return
                }
                
                switch errCode {
                case .emailAlreadyInUse:
                    onComplition(.emailInUse)
                case .networkError:
                    onComplition(.networkError)
                default:
                    onComplition(.unknownError)
                }
            }
        }
    }
    
    func signIn(email: String, password: String, onComplition: @escaping ((SignInResult)->())){
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult: AuthDataResult?, error: Error?) in
            
            if authDataResult?.user != nil {
                onComplition(.success)
            } else {
                guard let error = error, let errCode = AuthErrorCode(rawValue: error._code) else {
                    onComplition(.unknownError)
                    return
                }
                
                switch errCode {
                case .wrongPassword:
                    onComplition(.wrongPassword)
                case .networkError:
                    onComplition(.networkError)
                case .userNotFound:
                    onComplition(.emailNotExist)
                default:
                    onComplition(.unknownError)
                }
            }
            
        }
    }
    
    func signInWithCredential(credential: AuthCredential, onComplition: @escaping ((SignInWithCredentialResult)->())){
        Auth.auth().signInAndRetrieveData(with: credential) { (authDataResult: AuthDataResult?, error: Error?) in
            
            if authDataResult?.user != nil {
                onComplition(.success)
            } else {
                guard let error = error, let errCode = AuthErrorCode(rawValue: error._code) else {
                    onComplition(.unknownError)
                    return
                }
                
                switch errCode {
                case .networkError:
                    onComplition(.networkError)
                default:
                    onComplition(.unknownError)
                }
            }
            
        }
    }
    
    func logoutCurrentUser(onComplition: @escaping ((LogoutResult)->())){
        do {
            try Auth.auth().signOut()
            onComplition(.success)
        }catch (_) {
            onComplition(.unknownError)
        }
    }
}

enum SignUpResult {
    case success
    case emailInUse
    case networkError
    case unknownError
}

enum SignInResult {
    case success
    case emailNotExist
    case wrongPassword
    case networkError
    case unknownError
}

enum SignInWithCredentialResult {
    case success
    case networkError
    case unknownError
}

enum LogoutResult {
    case success
    case unknownError
}
