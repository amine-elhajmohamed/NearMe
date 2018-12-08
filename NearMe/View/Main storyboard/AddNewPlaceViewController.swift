//
//  AddNewPlaceViewController.swift
//  NearMe
//
//  Created by MedAmine on 12/8/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddNewPlaceViewController: UIViewController {
    
    @IBOutlet weak var btnAdd: LoadingButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnCoffee: UIButton!
    @IBOutlet weak var btnKidsEntertainment: UIButton!
    @IBOutlet weak var btnPark: UIButton!
    @IBOutlet weak var btnRestaurant: UIButton!
    @IBOutlet weak var btnBar: UIButton!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    private var isFirstTimeAppearing = true
    
    private var selectedPlaceType: PlaceType?
    
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
        
        lblError.text = ""
        
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
    
    private func changeAllTypesButtonAlpha(){
        btnCoffee.alpha = 0.5
        btnKidsEntertainment.alpha = 0.5
        btnPark.alpha = 0.5
        btnRestaurant.alpha = 0.5
        btnBar.alpha = 0.5
    }
    
    //MARK:- Actions
    
    private func attemtAddNewPlace() {
        guard let name = txtName.text, !name.isEmpty, !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            lblError.text = "Please enter a name for this place"
            return
        }
        
        guard let selectedPlaceType = selectedPlaceType else {
            lblError.text = "Please select this place type"
            return
        }
        
        view.isUserInteractionEnabled = false
        btnAdd.startAnimating()
        
        PlacesController.shared.createNewPlace(name: name, type: selectedPlaceType.rawValue, latitude: latitude, longitude: longitude) { [unowned self] (result: CreateNewPlaceResult) in
            self.btnAdd.stopAnimating {
                self.view.isUserInteractionEnabled = true
                
                switch result {
                case .success:
                    SVProgressHUD.showSuccess(withStatus: name + " added successfully")
                    self.dismissView()
                case .failed:
                    SVProgressHUD.showError(withStatus: "An error occurred\n\nPlease check your internet connection and try again.")
                }
            }
        }
        
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        lblError.text = ""
        
        switch sender {
        case btnAdd:
            attemtAddNewPlace()
        case btnCoffee:
            changeAllTypesButtonAlpha()
            btnCoffee.alpha = 1
            selectedPlaceType = PlaceType.coffee
        case btnKidsEntertainment:
            changeAllTypesButtonAlpha()
            btnKidsEntertainment.alpha = 1
            selectedPlaceType = PlaceType.kidsEntertainment
        case btnPark:
            changeAllTypesButtonAlpha()
            btnPark.alpha = 1
            selectedPlaceType = PlaceType.park
        case btnRestaurant:
            changeAllTypesButtonAlpha()
            btnRestaurant.alpha = 1
            selectedPlaceType = PlaceType.restaurant
        case btnBar:
            changeAllTypesButtonAlpha()
            btnBar.alpha = 1
            selectedPlaceType = PlaceType.bar
        case btnCancel:
            dismissView()
        default:
            break
        }
    }
    
    @IBAction func txtNameChanged(_ sender: UITextField) {
        lblError.text = ""
    }
    
    @IBAction func bgViewTaped(_ sender: UITapGestureRecognizer) {
        dismissView()
    }
}
