//
//  PlaceUtils.swift
//  NearMe
//
//  Created by MedAmine on 12/7/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit

class PlaceUtils {
    
    static let shared = PlaceUtils()
    
    func getPlaceIconForMarker(type: PlaceType) -> UIImage?{
        switch type {
        case .bar:
            return UIImage(named: "BarMarkerIcon")
        case .coffee:
            return UIImage(named: "CoffeeMarkerIcon")
        case .kidsEntertainment:
            return UIImage(named: "KidsEntertainmentMarkerIcon")
        case .restaurant:
            return UIImage(named: "ParkMarkerIcon")
        case .park:
            return UIImage(named: "RestaurantMarkerIcon")
        }
    }
    
}
