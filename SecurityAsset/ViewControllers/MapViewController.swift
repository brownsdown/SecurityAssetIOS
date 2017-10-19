//
//  MapViewController.swift
//  SecurityAsset
//
//  Created by michael moldawski on 18/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var user: AppUser?
    let locationManager = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    
    //test
    let coordinate = CLLocationCoordinate2D(latitude: 50.85186, longitude: 4.30618)
    let regionDistance: CLLocationDistance = 1000
    
    //test
    // Cette fonction est appellé à chaque fois que le user se déplace
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        
        
        
        self.map.showsUserLocation = true
        self.user?.location.latitude = myLocation.latitude
        self.user?.location.longitude = myLocation.longitude
        print("latitude: \(myLocation.latitude) longitude: \(myLocation.longitude)")
        
        locationManager.stopUpdatingLocation()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let tbcv = self.tabBarController as! MyUITabBarController
        self.user = tbcv.user
        map.delegate = self
        let annotation = MyPointAnnotation()
        annotation.coordinate = self.coordinate
        annotation.title = self.user?.firstName
        annotation.subtitle = self.user?.userState.rawValue
        annotation.pinTintColor = UIColor.green
        
        
        map.addAnnotation(annotation)
        map.showsScale = true
        map.showsTraffic = true
        map.showsPointsOfInterest = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // MARK: - Request authorisation from the user for the foreground
        //       locationManager.requestWhenInUseAuthorization()
        // MARK: - Request authorisation from the user for the background
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        //        print("latitude: \(locationManager.location?.coordinate.latitude) longitude:\(locationManager.location?.coordinate.latitude))")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation?.subtitle! == "Safe"
        {
            //            let location = view.annotation?.coordinate
            self.mapItem().openInMaps(launchOptions: nil)
            
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
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
    
    func mapItem() -> MKMapItem {
        
        let placemark = MKPlacemark(coordinate: self.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}

class MyPointAnnotation : MKPointAnnotation {
    var pinTintColor: UIColor?
}
