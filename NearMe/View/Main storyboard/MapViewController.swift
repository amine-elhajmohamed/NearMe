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
    
    private let locationManager = CLLocationManager()
    
    private var isFirstTimeAppearing = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTimeAppearing {
            isFirstTimeAppearing = false
            
            requestGpsPermission()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    //MARK:- View configurations
    
    private func configureView(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        
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
    
    private func requestGpsPermission(){
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func getDirectionToPlace(place: Place, onComplition: @escaping ((Bool)->())) {
        guard let currentUserLocation = locationManager.location?.coordinate else {
            return
        }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: currentUserLocation, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else {
                onComplition(false)
                return
            }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
            
            onComplition(true)
        }
    }
    
    @IBAction func mapViewLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            let touchPoint = sender.location(in: mapView)
            let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            if let addNewPlaceVC = storyboard?.instantiateViewController(withIdentifier: "AddNewPlaceVC") as? AddNewPlaceViewController {
                addNewPlaceVC.latitude = coordinates.latitude
                addNewPlaceVC.longitude = coordinates.longitude
                present(addNewPlaceVC, animated: false, completion: nil)
            }
        }
        
    }
}

//MARK:- extension MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
        
        guard let annotation = view.annotation as? PlaceAnnotation else {
            return
        }
        
        if let placeMapDetailsVC = storyboard?.instantiateViewController(withIdentifier: "PlaceMapDetailsVC") as? PlaceMapDetailsViewController {
            placeMapDetailsVC.presentingMapView = self
            placeMapDetailsVC.place = annotation.place
            present(placeMapDetailsVC, animated: false, completion: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PlaceAnnotation else {
            return nil
        }
        
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
}
