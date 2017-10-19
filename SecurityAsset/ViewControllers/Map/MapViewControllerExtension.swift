//
//  mapViewControllerExtension.swift
//  SecurityAsset
//
//  Created by michael moldawski on 19/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate
{
     //MARK:- CLLocationManagerDelegate
    // Cette fonction est appellé à chaque fois que le user se déplace
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        //        self.map.showsUserLocation = true
        self.user?.location.latitude = myLocation.latitude
        self.user?.location.longitude = myLocation.longitude
        print("latitude: \(myLocation.latitude) longitude: \(myLocation.longitude)")
        
        locationManager.stopUpdatingLocation()
        
    }
    
    //MARK:- MKMapViewDelegate
    // cette fonction permet de retourner un objet de type MKmaps qui ouvrent la navigation dans maps
    func mapItem() -> MKMapItem {
        
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (self.user?.location.latitude)!, longitude: (self.user?.location.longitude)!))
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
        } else {
            annotationView?.annotation = annotation
        }
        
        if let annotation = annotation as? MyPointAnnotation {
            annotationView?.pinTintColor = annotation.pinTintColor
        }
        
        return annotationView
    }
}
