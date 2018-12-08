//
//  PlacesNearYouTableViewCell.swift
//  NearMe
//
//  Created by MedAmine on 12/8/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class PlacesNearYouTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblError: UILabel!
    
    private let realm = try! Realm()
    
    private var _places: Results<Place>!
    private var places: [Place] = []
    
    var notificationToken: NotificationToken? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "PlaceNearYouCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlaceNearYouCollectionViewCell")
        
        lblError.isHidden = true
        
        _places = realm.objects(Place.self)
        
        notificationToken = _places.observe({ [weak self] (_) in
            guard let self = self else {
                return
            }
            
            self.reloadPlacesTable()
            
            if self.places.count > 0 {
                self.lblError.isHidden = true
            } else {
                self.lblError.isHidden = false
            }
            
            self.collectionView.reloadData()
        })
    }
    
    private func reloadPlacesTable(){
        guard let currentUserLocation = CLLocationManager().location else {
            places = Array(_places)
            return
        }
        
        places = _places.filter({ (place: Place) -> Bool in
            return PlaceUtils.shared.getDistanceBetween(location1: currentUserLocation, location2: CLLocation(latitude: place.latitude, longitude: place.longitude)) <= 100000
        })
        
        places = places.sorted(by: { (p1: Place, p2: Place) -> Bool in
            return PlaceUtils.shared.getDistanceBetween(location1: currentUserLocation, location2: CLLocation(latitude: p1.latitude, longitude: p1.longitude)) <= PlaceUtils.shared.getDistanceBetween(location1: currentUserLocation, location2: CLLocation(latitude: p2.latitude, longitude: p2.longitude))
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        notificationToken?.invalidate()
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
        
        collectionView.contentInset = UIEdgeInsets(top: 200, left: 200, bottom: 200, right: 200)
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
}

extension PlacesNearYouTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceNearYouCollectionViewCell", for: indexPath) as! PlaceNearYouCollectionViewCell
        cell.configureWithPlace(place: places[indexPath.row])
        return cell
    }
    
}
