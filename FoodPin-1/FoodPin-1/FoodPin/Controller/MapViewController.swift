//
//  MapViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 30/10/2019.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
        
    var restaurant: RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location ?? "", completionHandler: { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // Display the annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
            
        })
        
        
        // Configure map view
        mapView.delegate = self
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
    }
    

    // MARK: - Map View Delegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMarker"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.glyphText = "😋"
        annotationView?.markerTintColor = UIColor.orange
        
        return annotationView
    }
    
    
    @IBAction func showMeWhere(_ sender: Any) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location ?? "" , completionHandler: {(placemarks:[CLPlacemark]!,error:Error!) in
            if error != nil{
                print(error!)
                return
            }
            if placemarks != nil && placemarks.count > 0{
                let placemark = placemarks[0] as CLPlacemark
                print("\(placemark.location?.coordinate.latitude ?? 0.0),\(placemark.location?.coordinate.longitude ?? 0.0)")
                let latitude: CLLocationDegrees = placemark.location?.coordinate.latitude ?? 0.0
                let longitude: CLLocationDegrees = placemark.location?.coordinate.longitude ?? 0.0
                let regionDistance: CLLocationDistance = 1000;
                let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                let regionSpan = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
                
                let placemark123 = MKPlacemark(coordinate: coordinates)
                let mapItem = MKMapItem(placemark: placemark123)
                mapItem.name = self.restaurant.name
                mapItem.openInMaps(launchOptions: options)
            }
        })
        
    }
    
}
