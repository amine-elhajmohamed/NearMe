//
//  NearMeViewController.swift
//  NearMe
//
//  Created by MedAmine on 12/8/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import FirebaseAuth
import RealmSwift
import SVProgressHUD

class NearMeViewController: UIViewController {

    @IBOutlet weak var btnLogout: UIButton!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topView: UIView!
    
    private static let SECTION_NEAR_ME = 0
    private static let SECTION_PLACES_RATED_TITLE = 1
    private static let SECTION_PLACES_RATED = 2
    
    private let realm = try! Realm()
    
    private var myRatesPlaces: Results<Place>!
    
    var notificationToken: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    //MARK:- View configurations
    
    private func configureView(){
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topView.layer.shadowOpacity = 0.3
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "PlacesNearYouTableViewCell", bundle: nil), forCellReuseIdentifier: "PlacesNearYouTableViewCell")
        tableView.register(UINib(nibName: "PlaceRatedTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceRatedTableViewCell")
        
        lblEmail.text = Auth.auth().currentUser?.email ?? "Unknown User"
        
        myRatesPlaces = realm.objects(Place.self).filter("myRating > 0").sorted(byKeyPath: "myRating", ascending: false)
        
        notificationToken = myRatesPlaces.observe({ [weak self] (changes: RealmCollectionChange<Results<Place>>) in
            guard let self = self else {
                return
            }
            
            switch changes {
            case .initial:
                guard self.myRatesPlaces.count > 0 else {
                    return
                }
                
                let reloadDataAt = (1...self.myRatesPlaces.count+1).map({ (value: Int) -> IndexPath in
                    return IndexPath(row: value, section: 0)
                })
                self.tableView.reloadRows(at: reloadDataAt, with: .none)
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                
                if insertions.count != 0 && self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) == nil {
                    self.tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .none)
                }
                
                self.tableView.insertRows(at: insertions.map({ (value: Int) -> IndexPath in
                    return IndexPath(row: value+2, section: 0) //+2 because 2 cell are reserver for Places near you and for the title of this section
                }), with: .none)
                self.tableView.deleteRows(at: deletions.map({ (value: Int) -> IndexPath in
                    return IndexPath(row: value+2, section: 0) //+2 because 2 cell are reserver for Places near you and for the title of this section
                }), with: .none)
                self.tableView.reloadRows(at: modifications.map({ (value: Int) -> IndexPath in
                    return IndexPath(row: value+2, section: 0) //+2 because 2 cell are reserver for Places near you and for the title of this section
                }), with: .none)
                self.tableView.endUpdates()
            default:
                break
            }
        })
    }

    deinit {
        notificationToken?.invalidate()
    }
    
    
    //MARK:- Actions
    
    @IBAction func btnClicked(_ sender: UIButton) {
        switch sender {
        case btnLogout:
            AccountController.shared.logoutCurrentUser { [unowned self] (result: LogoutResult) in
                switch result {
                case .success:
                    self.dismiss(animated: true, completion: nil)
                    MainTabViewController.ref = nil
                    try! self.realm.write {
                        self.realm.deleteAll()
                    }
                case .unknownError:
                    SVProgressHUD.showError(withStatus: "An unknown error occurred, please try again later.")
                }
            }
        default:
            break
        }
    }
    
}

//MARK:- extension UITableViewDelegate, UITableViewDataSource
extension NearMeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(1 + (myRatesPlaces.count > 0 ? 1 +  myRatesPlaces.count : 0))
        return 1 + (myRatesPlaces.count > 0 ? 1 +  myRatesPlaces.count : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.row {
        case NearMeViewController.SECTION_NEAR_ME:
            cell = tableView.dequeueReusableCell(withIdentifier: "PlacesNearYouTableViewCell", for: indexPath)
        case NearMeViewController.SECTION_PLACES_RATED_TITLE:
            cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell")
            if let lblTitle = cell.viewWithTag(9898) as? UILabel {
                lblTitle.text = "Your rated places"
            }
        default:
            let placeRatedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PlaceRatedTableViewCell", for: indexPath) as! PlaceRatedTableViewCell
            placeRatedTableViewCell.loadDataFromPlace(place: myRatesPlaces[indexPath.row - 2]) //-2 because there are 2 aditional cell, reserver for Places near you and for the title of this section
            
            cell = placeRatedTableViewCell
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row >= NearMeViewController.SECTION_PLACES_RATED {
            if let mainTabBarController = MainTabViewController.ref, let mapVC = mainTabBarController.viewControllers?[MainTabViewController.MAP_VC_INDEX] as? MapViewController {
                MainTabViewController.ref?.selectedIndex = MainTabViewController.MAP_VC_INDEX
                
                let place = myRatesPlaces[indexPath.item - 2] //-2 because there are 2 aditional cell, reserver for Places near you and for the title of this section
                mapVC.zoomTheMapToAPlace(place: place)
                mapVC.openPlaceDetails(place: place)
            }
        }
    }
    
}
