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
import FirebaseAuth

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
            self.parsePlaceFromSnapshot(snapshot: snapshot)
        }
        
        database.observe(.childChanged) { (snapshot: DataSnapshot) in
            self.parsePlaceFromSnapshot(snapshot: snapshot)
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
    
    func ratePlace(place: Place, rate: Int){
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let database = Database.database().reference().child("locations").child(place.identifier).child("rates").child(currentUserId)
        database.setValue(rate)
        
        try! realm.write {
            if place.myRating == 0 {
                place.rating = ((place.rating * Double(place.totalRates)) + Double(rate)) / Double(place.totalRates + 1)
                place.totalRates += 1
            } else {
                place.rating = ((place.rating * Double(place.totalRates)) + Double(rate - place.myRating)) / Double(place.totalRates)
            }
            
            place.myRating = rate
        }
    }
    
    
    private func parsePlaceFromSnapshot(snapshot: DataSnapshot){
        if let data = snapshot.value as? [String: AnyObject], let name = data["name"] as? String,
            let latitude = data["lat"] as? Double, let longitude = data["long"] as? Double, let type = data["type"] as? String {
            
            let identifier = snapshot.key
            
            var totalRates = 0
            var totalRatesCount = 0
            var myRating = 0
            
            if let rates = data["rates"] as? [String: Int] {
                totalRatesCount = rates.count
                
                for element in rates {
                    totalRates += element.value
                }
                
                if let currentUserRating = rates[Auth.auth().currentUser?.uid ?? ""] {
                    myRating = currentUserRating
                }
            }
            
            var place: Place! = nil
            
            let setPlaceProprities = {
                place.name = name
                place.latitude = latitude
                place.longitude = longitude
                place._type = type
                place.rating = totalRatesCount == 0 ? 0 : Double(totalRates / totalRatesCount)
                place.totalRates = totalRatesCount
                place.myRating = myRating
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
}


enum CreateNewPlaceResult {
    case success
    case failed
}
