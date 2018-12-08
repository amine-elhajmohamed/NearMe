//
//  NearMeViewController.swift
//  NearMe
//
//  Created by MedAmine on 12/8/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import RealmSwift

class NearMeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
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
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "PlacesNearYouTableViewCell", bundle: nil), forCellReuseIdentifier: "PlacesNearYouTableViewCell")
        tableView.register(UINib(nibName: "PlaceRatedTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceRatedTableViewCell")
        
        myRatesPlaces = realm.objects(Place.self).filter("myRating > 0").sorted(byKeyPath: "myRating", ascending: false)
        
        notificationToken = myRatesPlaces.observe({ [weak self] (changes: RealmCollectionChange<Results<Place>>) in
            guard let self = self else {
                return
            }
            
            switch changes {
            case .initial:
                let reloadDataAt = (1...self.myRatesPlaces.count+1).map({ (value: Int) -> IndexPath in
                    return IndexPath(row: value, section: 0)
                })
                self.tableView.reloadRows(at: reloadDataAt, with: .none)
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
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
