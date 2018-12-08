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
    
    func getPlaceIcon(type: PlaceType) -> UIImage?{
        switch type {
        case .bar:
            return UIImage(named: "BarIcon")
        case .coffee:
            return UIImage(named: "CoffeeIcon")
        case .kidsEntertainment:
            return UIImage(named: "KidsEntertainmentIcon")
        case .restaurant:
            return UIImage(named: "ParkIcon")
        case .park:
            return UIImage(named: "RestaurantIcon")
        }
    }
    
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
