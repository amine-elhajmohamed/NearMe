//
//  NearMeViewController.swift
//  NearMe
//
//  Created by MedAmine on 12/8/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit

class NearMeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private static let SECTION_NEAR_ME = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    //MARK:- View configurations
    
    private func configureView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "PlacesNearYouTableViewCell", bundle: nil), forCellReuseIdentifier: "PlacesNearYouTableViewCell")
    }

}

//MARK:- extension UITableViewDelegate, UITableViewDataSource
extension NearMeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case NearMeViewController.SECTION_NEAR_ME:
            return tableView.dequeueReusableCell(withIdentifier: "PlacesNearYouTableViewCell", for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
}
