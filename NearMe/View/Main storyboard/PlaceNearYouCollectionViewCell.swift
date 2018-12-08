//
//  PlaceNearYouCollectionViewCell.swift
//  NearMe
//
//  Created by MedAmine on 12/8/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit

class PlaceNearYouCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    
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
        lblDistance.text = ""
        
        img.image = nil
    }
}
