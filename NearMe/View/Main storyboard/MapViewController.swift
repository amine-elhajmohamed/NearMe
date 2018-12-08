//
//  MapViewController.swift
//  NearMe
//
//  Created by MedAmine on 12/7/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private let realm = try! Realm()
    
    private var places: Results<Place>!
    
    var notificationToken: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    //MARK:- View configurations
    
    private func configureView(){
        mapView.delegate = self
        
        places = realm.objects(Place.self)
        
        notificationToken = places.observe({ [weak self] (changes: RealmCollectionChange<Results<Place>>) in
            guard let self = self else {
                return
            }
            
            switch changes {
            case .initial:
                for place in self.places {
                    let placeAnnotation = PlaceAnnotation(place: place)
                    self.mapView.addAnnotation(placeAnnotation)
                }
            case .update(_, _, let insertions, _):
                for index in insertions {
                    let place = self.places[index]
                    let placeAnnotation = PlaceAnnotation(place: place)
                    self.mapView.addAnnotation(placeAnnotation)
                }
            default:
                break
            }
        })

    }

    deinit {
        notificationToken?.invalidate()
    }
    
    //MARK:- Actions
    
    @IBAction func mapViewLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            let touchPoint = sender.location(in: mapView)
            let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let addNewPlaceVC = storyboard?.instantiateViewController(withIdentifier: "AddNewPlaceVC") as! AddNewPlaceViewController
            addNewPlaceVC.latitude = coordinates.latitude
            addNewPlaceVC.longitude = coordinates.longitude
            present(addNewPlaceVC, animated: false, completion: nil)
        }
        
    }
}

//MARK:- extension MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("test")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PlaceAnnotation else { return nil }
        
        let annotationIdentifier = annotation.place._type
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        } else {
            annotationView!.annotation = annotation
        }
        
        annotationView!.image = PlaceUtils.shared.getPlaceIconForMarker(type: annotation.place.type)
        
        return annotationView
    }
    
}
