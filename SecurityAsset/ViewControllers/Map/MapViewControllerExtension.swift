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
extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate
{
    //MARK:- CLLocationManagerDelegate
    // Cette fonction est appellé à la première position de l'utilisateur afin de centrer la carte sur lui, ensuite on arrêtte le update qui se fera via le dashboard qui n'est pas écrasé, car dans un tabbar
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        self.user?.location.latitude = myLocation.latitude
        self.user?.location.longitude = myLocation.longitude
        
        locationManager.stopUpdatingLocation()
        
    }
    
    //MARK:- MKMapViewDelegate
    
    // Cette fonction permet de créer une fenettres d'information lorsqu'on clique sur une annotation point, et sauve l'information dans "annotationForAuxiliaryView"
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.annotationForAuxiliaryView = view
        self.auxiliaryView.isHidden = false
        let test = view.annotation as! MyPointAnnotation
        self.firstnameAuxiliaryVewLabel.text = test.user.firstName
        self.LastnameAuxiliaryViewLabel.text = test.user.lastName
        self.UserStatusAuxiliaryViewLabel.text = test.user.userState.rawValue
        
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
        annotationView?.canShowCallout = true
        return annotationView
    }
    
    //Cette fonction ne fait pas partie de MKMapViewDelegate
    // cette fonction transforme une annotation en type MKmaps qui ouvrent la navigation dans maps
    func mapItem(myAnnotation: MKAnnotationView) -> MKMapItem {
        let latitude = myAnnotation.annotation?.coordinate.latitude
        let longitude = myAnnotation.annotation?.coordinate.longitude
        
        
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = myAnnotation.annotation?.title!
        
        return mapItem
    }
    
    //Mark : - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // La méthode ci-dessous est utilisée par la méthode suivante
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userFriends.count
    }
    //La méthode ci-dessous est utiliser pour implémenter, et mettre à jours, la table view avec le tableau de data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = userFriends[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapUser", for: indexPath) as! MapUserTableViewCell
        cell.user = user
        return cell
    }
    //Mark : - TableView Delegate
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = self.userFriendsTableView.cellForRow(at: indexPath) as! MapUserTableViewCell
            zoomTo(user: cell.user!)
        }
}
