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
import FirebaseDatabase
import FirebaseAuth
import SwiftyJSON


class MapViewController: UIViewController
{
    var user: AppUser?
    let locationManager = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    var userFriends =  [AppUser] ()
    var tempUser: AppUser?
    var dbRef = FireBaseManager.databaseRef
    var annotationForAuxiliaryView: MKAnnotationView?
    
    
    @IBAction func logInButton(_ sender: Any) {
        self.dismiss(animated: true) {}
        self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
    }
    @IBOutlet weak var auxiliaryView: UIView!
    
    
    @IBOutlet weak var firstnameAuxiliaryVewLabel: UILabel!
    @IBOutlet weak var LastnameAuxiliaryViewLabel: UILabel!
    @IBOutlet weak var UserStatusAuxiliaryViewLabel: UILabel!
    
      @IBOutlet weak var goButton: UIButton!
    @IBAction func closeAuxiliaryView(_ sender: Any) {
        self.auxiliaryView.isHidden = true
//        self.goButton.isEnabled = false
    }
    
    @IBAction func goToMaps(_ sender: Any) {
        self.mapItem(myAnnotation: self.annotationForAuxiliaryView!).openInMaps(launchOptions: nil)
    }
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.annotationForAuxiliaryView = MKAnnotationView()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let tbcv = self.tabBarController as! MyUITabBarController
        self.user = tbcv.user
        self.userAnnotation(user: self.user)
        self.searchUserInGroup()

        
        map.showsScale = true
        map.showsTraffic = true
        
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
    
    
    func userAnnotation(user: AppUser?)
    {
        let annotation = MyPointAnnotation()
        annotation.user = user!
        annotation.coordinate = CLLocationCoordinate2D(latitude: (user?.location.latitude)!, longitude: (user?.location.longitude)!)
        annotation.title = user?.firstName
        annotation.subtitle = user?.userState.rawValue
       
        if annotation.subtitle == "Safe"
        {
            annotation.pinTintColor = UIColor.green
        }
        else
        {
            annotation.pinTintColor = UIColor.red
        }
        
        
        map.addAnnotation(annotation)
    }
    
    func searchUserInGroup()
    {
        //        var UserFirebaseID = self.user?.userFireBase?.uid

        
        let groupToTrack =  (self.user?.group.group[0])!
        
        let groupUserRef = self.dbRef.child("Group").child(groupToTrack)
        groupUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value
            {
                let json = JSON(value)
                for (key,_) in json
                {
                    if key != FireBaseManager.shared.currentUser?.uid
                    {
                        let userTemp: AppUser = AppUser(fireBaseUser: key)!
                        userTemp.updateUserFromDBwithUID(uid: key, handler: { value in
                           self.userFriends.append(userTemp)
                            self.userAnnotation(user: userTemp)
                            
                            
                        })
                    }
                }
            }
            
            let annotations = self.map.annotations
            for annotation in annotations
            {
            self.map.selectAnnotation(annotation, animated: true)
            }
            self.map.delegate = self
        })
        
    }
}
class MyPointAnnotation : MKPointAnnotation
{
    var user = AppUser()
    var pinTintColor: UIColor?
}
