//
//  PlaceRatedTableViewCell.swift
//  NearMe
//
//  Created by MedAmine on 12/8/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import HCSStarRatingView

class PlaceRatedTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var startsRating: HCSStarRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lblName.text = ""
        img.image = nil
        startsRating.value = 0
    }
    
    func loadDataFromPlace(place: Place){
        lblName.text = place.name
        img.image = PlaceUtils.getPlaceIcon(type: place.type)
        startsRating.value = CGFloat(place.myRating)
    }
    
}
