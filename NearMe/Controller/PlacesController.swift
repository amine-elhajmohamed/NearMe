//
//  PlacesController.swift
//  NearMe
//
//  Created by MedAmine on 12/7/18.
//  Copyright © 2018 amine. All rights reserved.
//

import Foundation
import FirebaseDatabase
import RealmSwift

class PlacesController {
    
    static let shared = PlacesController()
    
    private var isStarted = false
    
    private let realm = try! Realm()
    
    func start(){
        guard !isStarted else {
            return
        }
        
        isStarted = true
        
        let database = Database.database().reference().child("locations")
        
        database.observe(.childAdded) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? [String: AnyObject], let name = data["name"] as? String,
                let latitude = data["lat"] as? Double, let longitude = data["long"] as? Double,
                let rating = data["rating"] as? Double, let type = data["type"] as? String {
                
                let identifier = snapshot.key
                
                var place: Place! = nil
                
                let setPlaceProprities = {
                    place.name = name
                    place.latitude = latitude
                    place.longitude = longitude
                    place._type = type
                    place.rating = rating
                }
                
                place = self.realm.object(ofType: Place.self, forPrimaryKey: identifier)
                
                if place != nil {
                    try! self.realm.write {
                        setPlaceProprities()
                    }
                } else {
                    place = Place()
                    place.identifier = snapshot.key
                    setPlaceProprities()
                    try! self.realm.write {
                        self.realm.add(place)
                    }
                }
                
            }
            
        }
        
        //observe rating change
        database.observe(.childChanged) { (snapShot: DataSnapshot) in
            
            if let data = snapShot.value as? [String: AnyObject], let rating = data["rating"] as? Double {
                
                let identifier = snapShot.key
                if let place = self.realm.object(ofType: Place.self, forPrimaryKey: identifier) {
                    try! self.realm.write {
                        place.rating = rating
                    }
                }
                
            }
            
        }
        
    }
    
    
    func createNewPlace(name: String, type: String, latitude: Double, longitude: Double, onComplition: @escaping ((CreateNewPlaceResult)->())){
        let database = Database.database().reference().child("locations")
        
        let valueToAdd: [String: Any] = ["name": name, "type": type, "lat": latitude, "long": longitude, "rating": 0]
        
        database.childByAutoId().setValue(valueToAdd) { (error: Error?, ref: DatabaseReference) in
            if error == nil {
                onComplition(.success)
            } else {
                onComplition(.failed)
            }
        }
    }
}


enum CreateNewPlaceResult {
    case success
    case failed
}
