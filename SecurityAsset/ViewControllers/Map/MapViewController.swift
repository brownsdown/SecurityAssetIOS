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
    var userFriends =  [AppUser] ()
    var dbRef = FireBaseManager.databaseRef
    
    //la variable sert à récupérer l'annotation du point qu'on selectionne sur la map afin de préparer son envoi vers Maps
    var annotationForAuxiliaryView: MKAnnotationView?
    
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var auxiliaryView: UIView!
    @IBOutlet weak var firstnameAuxiliaryVewLabel: UILabel!
    @IBOutlet weak var LastnameAuxiliaryViewLabel: UILabel!
    @IBOutlet weak var UserStatusAuxiliaryViewLabel: UILabel!
    
    @IBOutlet weak var goButton: UIButton!
    
    @IBAction func closeAuxiliaryView(_ sender: Any) {
        self.auxiliaryView.isHidden = true
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
        self.map.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let tbcv = self.tabBarController as! MyUITabBarController
        self.user = tbcv.user
        locationManager.startUpdatingLocation()
        self.searchUserInGroup()
        
        map.showsScale = true
        map.showsTraffic = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Cette méthode permet de crées les annotations et les ajouter à la map
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
    
    //On va chercher tous les users appartenant au groupe dans la table Group, afin de les placer dans userFriends et on les dispose sur la map
    func searchUserInGroup()
    {
        // Ici on écoute le premier groupe de la liste, à améliorer
        let groupToTrack =  (self.user?.group.group[0])!
        
        let groupUserRef = self.dbRef.child("Group").child(groupToTrack)
        groupUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value
            {
                let json = JSON(value)
                for (key,_) in json
                {
                    
                    let userTemp: AppUser = AppUser(fireBaseUser: key)!
                    // On attent que firebase retourne les valeurs et ensuite on rempli la table userFriends et on dispose les points sur la carte
                    userTemp.updateUserFromDBwithUID(uid: key, handler: { value in
                        self.userFriends.append(userTemp)
                        self.userAnnotation(user: userTemp)
                    })
                    
                }
            }

            self.keepGroupTracking()
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
                                if newTempUser?.email == self.user?.email
                                {
                                    self.zoomTo(user: newTempUser!)
                                }
                            }
                            i += 1
                        }
                        i = 0
                        
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
    
    func zoomTo(user: AppUser)
    {
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake((user.location.latitude), (user.location.longitude))
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        self.map.setRegion(region, animated: true)
    }
}
class MyPointAnnotation : MKPointAnnotation
{
    var user = AppUser()
    var pinTintColor: UIColor?
}
