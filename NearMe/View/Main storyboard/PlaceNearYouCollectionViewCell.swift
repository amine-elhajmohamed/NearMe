//
//  PlaceNearYouCollectionViewCell.swift
//  NearMe
//
//  Created by MedAmine on 12/8/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceNearYouCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRates: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    
    private var place: Place!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 15
        
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize(width: 3, height: 3)
        bgView.layer.shadowOpacity = 0.2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lblName.text = ""
        lblRating.text = ""
        lblRates.text = ""
        lblDistance.text = ""
        
        img.image = nil
        
        place = nil
    }
    
    func configureWithPlace(place: Place){
        self.place = place
        
        lblName.text = place.name
        lblRating.text = String(format: "%.01f", place.rating)
        lblRates.text = "\(self.place.totalRates) rates"
        lblDistance.text = ""
        
        if let currentUserLocation = CLLocationManager().location {
            let distance = PlaceUtils.getDistanceBetween(location1: currentUserLocation, location2: CLLocation(latitude: place.latitude, longitude: place.longitude))
            if distance < 1000 {
                lblDistance.text = "\(distance) m"
            } else {
                lblDistance.text = "\(distance/1000) Km"
            }
        }
        
        img.image = PlaceUtils.getPlaceIcon(type: place.type)
    }
}
