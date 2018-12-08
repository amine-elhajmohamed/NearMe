//
//  PlaceMapDetailsViewController.swift
//  NearMe
//
//  Created by MedAmine on 12/8/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import HCSStarRatingView
import RealmSwift
import CoreLocation
import SVProgressHUD

class PlaceMapDetailsViewController: UIViewController {

    @IBOutlet weak var btnDirection: LoadingButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnZoomMap: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRated: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var startsRating: HCSStarRatingView!
    
    var presentingMapView: MapViewController?
    
    var place: Place!
    
    private var notificationToken : NotificationToken?
    
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
        
        lblName.text = place.name
        lblRating.text = String(format: "%.01f", place.rating)
        lblRated.text = "\(place.totalRates) rates"
        img.image = PlaceUtils.getPlaceIcon(type: place.type)
        startsRating.value = CGFloat(place.myRating)
        
        notificationToken = place.observe({ [weak self] (change) in
            guard let self = self else {
                return
            }
            
            switch change {
            case .change(_):
                self.lblRating.text = String(format: "%.01f", self.place.rating)
                self.lblRated.text = "\(self.place.totalRates) rates"
            default:
                break
            }
        })
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
        notificationToken?.invalidate()
        notificationToken = nil
        
        closeView(animated: true) { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
    }

    //MARK:- Actions
    
    private func attemtGetDirection(){
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            let alertVC = UIAlertController(title: "Allow GPS", message: "In order to use direction, the app need to access the GPS.\n Please enabled GPS access for the app.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Open settings", style: .default, handler: { (_) in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }))
            alertVC.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
            return
        }
        
        guard CLLocationManager().location != nil else {
            let alertVC = UIAlertController(title: "Failed to get your possition", message: "An error has been occured and couldn't detect your postion, please try again later.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
            return
        }
        
        view.isUserInteractionEnabled = false
        btnDirection.startAnimating()
        
        presentingMapView?.getDirectionToPlace(place: place, onComplition: { [weak self] (success: Bool) in
            
            self?.view.isUserInteractionEnabled = true
            self?.btnDirection.stopAnimating {
                if success {
                    self?.dismissView()
                } else {
                    SVProgressHUD.showError(withStatus: "An error occurred\n\nPlease check your internet connection and try again.")
                }
            }
        })
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        switch sender {
        case btnDirection:
            attemtGetDirection()
        case btnZoomMap:
            presentingMapView?.zoomTheMapToAPlace(place: place)
            dismissView()
        case btnClose:
            dismissView()
        default:
            break
        }
    }
    
    @IBAction func startViewRatingChanged(_ sender: HCSStarRatingView) {
        PlacesController.shared.ratePlace(place: place, rate: Int(sender.value))
    }
    
    @IBAction func bgViewTaped(_ sender: Any) {
        dismissView()
    }
}
