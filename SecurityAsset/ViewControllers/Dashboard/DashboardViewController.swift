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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbcv = self.tabBarController as! MyUITabBarController
        self.user = tbcv.user
        self.user?.resetUserPhonePosition()
        
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
                        if self.timer?.isValid ?? false
                        {
                            
                        }
                        else
                        {
                            self.startTimer()
                        }
                    }
                }
                else
                {
                    self.user?.userState = StateUser.safe
                    if self.timer?.isValid ?? false
                    {
                        self.timer?.invalidate()
                    }
                }
                self.xPositionLabel.text = String(xPosition)
                self.yPositionLabel.text = String(yPosition)
                self.zPositionLabel.text = String(zPosition)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer ()
    {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { timer in
            print("Timer")
            self.user?.userState = StateUser.unsafe
        })
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
