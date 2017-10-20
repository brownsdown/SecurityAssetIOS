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
    var userFriends: [AppUser]?
    var tempUser: AppUser?
    
    var dbRef = FireBaseManager.databaseRef
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let tbcv = self.tabBarController as! MyUITabBarController
        self.user = tbcv.user
        self.userAnnotation(user: self.user)
        
        
        
        self.searchUserInGroup()
        
        for annotation in self.map.annotations
        {
            map.selectAnnotation(annotation, animated: false)
        }
        
        map.delegate = self
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
        let user = user!
        annotation.coordinate = CLLocationCoordinate2D(latitude: user.location.latitude, longitude: user.location.longitude)
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
    }
    
    func searchUserInGroup()
    {
        //        var UserFirebaseID = self.user?.userFireBase?.uid
        var usersArray = [AppUser?]()
        
        let groupToTrack =  (self.user?.group.group[0])!
        
        let groupUserRef = self.dbRef.child("Group").child(groupToTrack)
        groupUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value
            {
                
                let json = JSON(value)
                for (key,value) in json
                {
                    if key != FireBaseManager.shared.currentUser?.uid
                    {
                        let userTemp: AppUser = AppUser(fireBaseUser: key)!
                        userTemp.updateUserFromDBwithUID(uid: key, handler: { value in
                            usersArray.append(userTemp)
                   
                        })
                    }
                }
            }
        })
   
    }
}
class MyPointAnnotation : MKPointAnnotation
{
    var pinTintColor: UIColor?
}
