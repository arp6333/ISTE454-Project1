//
//  ViewController.swift
//  NPF-4
//
//  Created by Ellie on 4/14/20.
//  Copyright © 2020 Ellie. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBAction func refresh() {
        print("refresh")
        activityIndicator.startAnimating()
        locationManager.startUpdatingLocation()
        activityIndicator.stopAnimating()
    }
    
    @IBAction func zoomIn() {
        // Zoom to user location
        activityIndicator.startAnimating()
        multiplier = 100000
        if let userLocation = locationManager.location?.coordinate {
            currentLocation = userLocation
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 20000, longitudinalMeters: 20000)
            mapView.setRegion(viewRegion, animated: true)
        }
        activityIndicator.stopAnimating()
    }
    
    @IBAction func zoomOut() {
        // If at default zoom, do nothing
        if multiplier == 0 {
            return
        }
        // Zoom out
        activityIndicator.startAnimating()
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: currentLocation ?? userLocation, latitudinalMeters: multiplier, longitudinalMeters: multiplier)
            mapView.setRegion(viewRegion, animated: true)
        }
        // Increase the multiplier
        multiplier = multiplier * 2
        activityIndicator.stopAnimating()
    }
    
    var multiplier: Double = 0
    var parks: [Park] = []
    var locationManager: CLLocationManager
    var currentLocation: CLLocationCoordinate2D?
    
    required init?(coder: NSCoder) {
        locationManager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        super.init(coder: coder)
        
        let scene = UIApplication.shared.connectedScenes.first
        if let delegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            if delegate.locationSet == true {
                currentLocation = delegate.currentLocation
                let viewRegion = MKCoordinateRegion(center: currentLocation!, latitudinalMeters: 5000, longitudinalMeters: 5000)
                delegate.locationSet = false
                mapView.setRegion(viewRegion, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        super.viewDidLoad()
        
        // Get all of the parks from the SceneDelegate
        let scene = UIApplication.shared.connectedScenes.first
        if let delegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            parks = delegate.parks
        }
        
        print("Number of parks: \(parks.count)")
        for park: Park in parks {
            mapView.addAnnotation(park)
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        let annotation = view.annotation
        print("The title of the annotation is: \(String(describing:annotation?.title))")
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKPinAnnotationView
        let identifier = "Pin"
        if annotation is MKUserLocation {
            // If annotation is not an MKPointAnnotation (eg. MKUserLocation),
            // return nil so map draws default view for it (eg. blue dot)...
            return nil
        }

        if annotation !== mapView.userLocation {
            // Look for an existing view to reuse
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                //view.pinColor = MKPinAnnotationColor.Purple
                view.pinTintColor = MKPinAnnotationView.redPinColor()
                view.animatesDrop = true
                view.canShowCallout = true
                //view.calloutOffset = CGPoint(x: -5, y: 5)
                let leftButton = UIButton(type: .infoLight)
                let rightButton = UIButton(type: .detailDisclosure)
                leftButton.tag = 0
                rightButton.tag = 1
                view.leftCalloutAccessoryView = leftButton
                view.rightCalloutAccessoryView = rightButton
            }
            return view
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        let parkAnnotation = view.annotation as! Park

        switch control.tag {
            case 0: // Left button
                if let url = URL(string: parkAnnotation.getLink()) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            case 1: // Right button
                //let coordinate = locationManager.location?.coordinate // Make sure location manager has updated before trying to use
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(
                    latitude: (parkAnnotation.getLocation()?.coordinate.latitude)!,
                    longitude: (parkAnnotation.getLocation()?.coordinate.longitude)!)))
                //let url = String(format: "http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f", coordinate?.latitude ?? 0,coordinate?.longitude ?? 0,(parkAnnotation.getLocation()?.coordinate.latitude)!,parkAnnotation.getLocation()?.coordinate.longitude ?? 0)
                //UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                mapItem.openInMaps(launchOptions: [:])
            default:
                break
        }
    }
    
    func setLocation(location: CLLocation) {
        // Zoom to set location
        multiplier = 100000
        let scene = UIApplication.shared.connectedScenes.first
        if let delegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            delegate.currentLocation = location.coordinate
            delegate.locationSet = true
        }
    }
}

