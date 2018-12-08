//
//  PlacesNearYouTableViewCell.swift
//  NearMe
//
//  Created by MedAmine on 12/8/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit

class PlacesNearYouTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "PlaceNearYouCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlaceNearYouCollectionViewCell")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
        
        collectionView.contentInset = UIEdgeInsets(top: 200, left: 200, bottom: 200, right: 200)
    }
    
}

extension PlacesNearYouTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceNearYouCollectionViewCell", for: indexPath)
    }
    
}
