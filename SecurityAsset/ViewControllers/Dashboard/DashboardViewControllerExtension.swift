//
//  DashboardViewControllerExtension.swift
//  SecurityAsset
//
//  Created by michael moldawski on 18/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
extension DashboardViewController: CLLocationManagerDelegate
{
    func startTimer ()
    {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { timer in
            print("Timer")
            self.user?.userState = StateUser.unsafe
            self.updateUserStatusLabel()
            self.locationManager.startUpdatingLocation()
        })
    }
    
    func accelerometerActivation()
    {
        //MARK:- Set Motion Manager Properties
        motionManager.accelerometerUpdateInterval = 0.2
        
        //MARK:- Start recording data
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
            if let myData = data
            {
                let xPosition = round(myData.acceleration.x * 10_000)/1000
                let yPosition = round(myData.acceleration.y * 10_000)/1000
                let zPosition = round(myData.acceleration.z * 10_000)/1000
                
                if abs(yPosition) < 3.0
                {
                    if self.user?.userState.rawValue != "Unsafe"
                    {
                        if !(self.timer?.isValid ?? false)
                        {
                            self.startTimer()
                        }
                    }
                }
                else
                {
                    if self.timer?.isValid ?? false
                    {
                        self.timer?.invalidate()
                    }
                    
                    if self.user?.userState.rawValue != "Safe"
                    {
                        self.user?.userState = StateUser.safe
                        self.updateUserStatusLabel()
                    }
                }
                self.xPositionLabel.text = String(xPosition)
                self.yPositionLabel.text = String(yPosition)
                self.zPositionLabel.text = String(zPosition)
            }
        }
    }
    
    func updateUserStatusLabel ()
    {
        if self.user?.userState.rawValue == StateUser.safe.rawValue
        {
            self.userStatusLabel.text = self.user?.userState.rawValue
            self.userStatusLabel.textColor = UIColor.green
        }
        else
        {
            self.userStatusLabel.text = self.user?.userState.rawValue
            self.userStatusLabel.textColor = UIColor.red
        }
        
    }
    
    func accelerometerDeactivation()
    {
        motionManager.stopAccelerometerUpdates()
        self.user?.userState = StateUser.safe
    }
    
    //MARK:- CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        self.user?.location.latitude = myLocation.latitude
        self.user?.location.longitude = myLocation.longitude
        locationManager.stopUpdatingLocation()
        
    }
    
}
