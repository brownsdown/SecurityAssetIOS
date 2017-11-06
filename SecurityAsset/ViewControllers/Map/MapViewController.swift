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
//import GameController permet de récupérer le vecteur de gravité


class MapViewController: UIViewController
{
    var user: AppUser?
    let locationManager = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    var userFriends =  [AppUser] ()
    var tempUser: AppUser? //TODO verifier si cette variable a toujours lieu d'être
    var dbRef = FireBaseManager.databaseRef
    var annotationForAuxiliaryView: MKAnnotationView?
    
    

    @IBOutlet weak var auxiliaryView: UIView!
    
    
    @IBOutlet weak var firstnameAuxiliaryVewLabel: UILabel!
    @IBOutlet weak var LastnameAuxiliaryViewLabel: UILabel!
    @IBOutlet weak var UserStatusAuxiliaryViewLabel: UILabel!
    
    @IBOutlet weak var goButton: UIButton!
    @IBAction func closeAuxiliaryView(_ sender: Any) {
        self.auxiliaryView.isHidden = true
        
        //        self.map.removeAnnotations(annotations)
    }
    
    @IBAction func logInButton(_ sender: Any) {
        self.dismiss(animated: true) {}
        self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
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
        self.searchUserInGroup()
        
        
        map.showsScale = true
        map.showsTraffic = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let groupToTrack =  (self.user?.group.group[0])!
        
        let groupUserRef = self.dbRef.child("Group").child(groupToTrack)
        groupUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value
            {
                let json = JSON(value)
                for (key,_) in json
                {
                    
                    let userTemp: AppUser = AppUser(fireBaseUser: key)!
                    // On attent que firebase retourne les valeurs et ensuite on les implémente dans
                    // l'anotation à être ajouter à la map
                    userTemp.updateUserFromDBwithUID(uid: key, handler: { value in
                        self.userFriends.append(userTemp)
                        self.userAnnotation(user: userTemp)
                    })
                    
                }
            }
            
            let annotations = self.map.annotations
            for annotation in annotations
            {
                self.map.selectAnnotation(annotation, animated: true)
            }
            self.map.delegate = self
                        self.keepGroupTracking()//
        })
        
    }
    
    // cette méthode permet de récupérer toutes les personnes du groupes dans le tableau user friend et afficher ces points à la carte
    func keepGroupTracking()
    {
        for group in (user?.group.group)!
        {
            FireBaseManager.databaseRef.child("Group").child(group).observe(DataEventType.childChanged, with: { snapshot in
                
                if let value = snapshot.value
                {
                    let key = snapshot.key
                    let newTempUser = AppUser(fireBaseUser: key)
                    newTempUser?.updateUserFromDBwithUID(uid: key, handler: { (true) in
                        var i = 0
                        for user in self.userFriends
                        {
                            if newTempUser?.email == user.email
                            {
                                self.userFriends[i] = newTempUser!
                            }
                           i += 1
                        }
                        i = 0
                        
                        print(newTempUser)
                    self.updateUserOnMap()
                    
                    })
                    
                }
                
            })
            
        }
    }
    
    func updateUserOnMap()
    {
        let annotations = self.map.annotations
        self.map.removeAnnotations(annotations)
        for user in userFriends
        {
            self.userAnnotation(user: user)
        }
    }
}
class MyPointAnnotation : MKPointAnnotation
{
    var user = AppUser()
    var pinTintColor: UIColor?
}
