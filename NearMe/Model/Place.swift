//
//  Place.swift
//  NearMe
//
//  Created by MedAmine on 12/7/18.
//  Copyright © 2018 amine. All rights reserved.
//

import RealmSwift

class Place: Object {
    
    @objc dynamic var identifier:String = "__"
    @objc dynamic var name:String = "__"
    @objc dynamic var _type:String = "__"
    @objc dynamic var rating: Double = 0
    @objc dynamic var totalRates: Int = 0
    @objc dynamic var myRating: Int = 0
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    var type: PlaceType {
        switch _type {
        case PlaceType.bar.rawValue:
            return .bar
        case PlaceType.coffee.rawValue:
            return .coffee
        case PlaceType.kidsEntertainment.rawValue:
            return .kidsEntertainment
        case PlaceType.restaurant.rawValue:
            return .restaurant
        case PlaceType.park.rawValue:
            return .park
        default:
            return .park
        }
    }
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
}

enum PlaceType: String {
    case bar = "bar"
    case coffee = "coffee"
    case kidsEntertainment = "kidsEntertainment"
    case restaurant = "restaurant"
    case park = "park"
}
