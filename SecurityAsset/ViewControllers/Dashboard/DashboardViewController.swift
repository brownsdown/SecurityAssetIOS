//
//  DashboardViewController.swift
//  SecurityAsset
//
//  Created by michael moldawski on 18/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation


class DashboardViewController: UIViewController {
    var user: AppUser?
    var motionManager = CMMotionManager()
    var timer: Timer?
    let locationManager = CLLocationManager()
    var deviceMotion = CMDeviceMotion()//
    @IBOutlet weak var userStatusLabel: UILabel!
    @IBOutlet weak var xPositionLabel: UILabel!
    @IBOutlet weak var yPositionLabel: UILabel!
    @IBOutlet weak var zPositionLabel: UILabel!
    
    @IBOutlet weak var dashboardSwitch: UISwitch!
    
    @IBAction func enablbeDisableAccelerometer(_ sender: UISwitch) {
        if sender.isOn
        {
            self.gravitySensorActivation()
        }
        else
        {
            self.timer?.invalidate()
            self.gravitySensorDeactivation()
            self.updateUserStatusLabel()
            self.xPositionLabel.text = "Sensor deactivated"
            self.yPositionLabel.text = "Sensor deactivated"
            self.zPositionLabel.text = "Sensor deactivated"
        }
    }
    
    @IBAction func returnToLogin(_ sender: Any) {
        self.gravitySensorDeactivation()
        self.timer?.invalidate()
        self.dismiss(animated: true) {}
        self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbcv = self.tabBarController as! MyUITabBarController
        self.user = tbcv.user
        self.user?.resetUserPhonePosition()
        self.locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true//

        
        self.updateUserStatusLabel()
        if dashboardSwitch.isOn
        {
            self.gravitySensorActivation()
        }
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
}
