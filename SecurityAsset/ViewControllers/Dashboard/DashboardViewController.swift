//
//  DashboardViewController.swift
//  SecurityAsset
//
//  Created by michael moldawski on 18/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import UIKit
import CoreMotion

class DashboardViewController: UIViewController {
    var user: AppUser?
    var motionManager = CMMotionManager()
    var timer: Timer?
    
    @IBOutlet weak var userStatusLabel: UILabel!
    @IBOutlet weak var xPositionLabel: UILabel!
    @IBOutlet weak var yPositionLabel: UILabel!
    @IBOutlet weak var zPositionLabel: UILabel!
    
    @IBOutlet weak var dashboardSwitch: UISwitch!
    
    @IBAction func enablbeDisableAccelerometer(_ sender: UISwitch) {
        if sender.isOn
        {
            self.accelerometerActivation()
        }
        else
        {
            self.accelerometerDeactivation()
            self.updateUserStatusLabel()
            self.xPositionLabel.text = "Sensor deactivated"
            self.yPositionLabel.text = "Sensor deactivated"
            self.zPositionLabel.text = "Sensor deactivated"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbcv = self.tabBarController as! MyUITabBarController
        self.user = tbcv.user
        self.user?.resetUserPhonePosition()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateUserStatusLabel()
        if dashboardSwitch.isOn
        {
            self.accelerometerActivation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.accelerometerDeactivation()
    }
    
}
