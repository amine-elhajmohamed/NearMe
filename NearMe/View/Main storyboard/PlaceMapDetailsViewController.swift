//
//  PlaceMapDetailsViewController.swift
//  NearMe
//
//  Created by MedAmine on 12/8/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit

class PlaceMapDetailsViewController: UIViewController {

    @IBOutlet weak var btnDirection: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRated: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    
    private var isFirstTimeAppearing = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTimeAppearing {
            isFirstTimeAppearing = false
            openView(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    //MARK:- View configurations
    
    private func configureView(){
        topView.layer.cornerRadius = 25
        
        topView.layer.shadowOpacity = 0.2
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: -10)
        
        closeView(animated: false)
    }
    
    private func openView(animated: Bool){
        let animationBlock = { [unowned self] in
            self.bgView.alpha = 1
            self.mainView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.topView.transform = self.mainView.transform
        }
        
        if animated {
            UIView.animate(withDuration: 0.5) {
                animationBlock()
            }
        } else {
            animationBlock()
        }
    }
    
    private func closeView(animated: Bool, onComplition: @escaping (()->()) = {}){
        let animationBlock = { [unowned self] in
            self.bgView.alpha = 0
            self.mainView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            self.topView.transform = self.mainView.transform
        }
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                animationBlock()
            }) { (_) in
                onComplition()
            }
        } else {
            animationBlock()
            onComplition()
        }
    }
    
    private func dismissView(){
        closeView(animated: true) { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
    }

    //MARK:- Actions
    
    @IBAction func bgViewTaped(_ sender: Any) {
        dismissView()
    }
}
