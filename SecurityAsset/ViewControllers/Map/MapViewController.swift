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


class MapViewController: UIViewController {
    var user: AppUser?
    let locationManager = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    var userFriends: [AppUser]?
    
    //test
    let coordinate = CLLocationCoordinate2D(latitude: 50.85186, longitude: 4.30618)
    let regionDistance: CLLocationDistance = 1000
    
    //test

    
    
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
        if annotation.subtitle == "Safe"
        {
            annotation.pinTintColor = UIColor.green
        }
        else
        {
            annotation.pinTintColor = UIColor.red
        }
        
        
        map.addAnnotation(annotation)
        map.showsScale = true
        map.showsTraffic = true
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
    
    // Cette fonction permet d'ouvrire maps en appuiyant sur le point
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
                  self.mapItem().openInMaps(launchOptions: nil)

    }
}

class MyPointAnnotation : MKPointAnnotation {
    var pinTintColor: UIColor?
}
