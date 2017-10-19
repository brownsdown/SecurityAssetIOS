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

class MapViewController: UIViewController, CLLocationManagerDelegate {
    var user: AppUser?
    let locationManager = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    
    // Cette fonction est appellé à chaque fois que le user se déplace
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
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
    }
    override func viewWillAppear(_ animated: Bool) {
        // MARK: - Request authorisation from the user for the foreground
//       locationManager.requestWhenInUseAuthorization()
        // MARK: - Request authorisation from the user for the background
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
