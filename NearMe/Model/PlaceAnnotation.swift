//
//  PlaceAnnotation.swift
//  NearMe
//
//  Created by MedAmine on 12/7/18.
//  Copyright © 2018 amine. All rights reserved.
//

import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    
    let place: Place
    var coordinate: CLLocationCoordinate2D
    
    init(place: Place) {
        self.place = place
        coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        
        super.init()
    }
    
}

