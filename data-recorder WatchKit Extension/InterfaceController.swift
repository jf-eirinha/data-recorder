//
//  InterfaceController.swift
//  data-recorder WatchKit Extension
//
//  Created by XCodeClub on 2019-05-01.
//  Copyright © 2019 dataset-devteam. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    
    @IBOutlet weak var accelerometerXLabel: WKInterfaceLabel!
    @IBOutlet weak var accelerometerYLabel: WKInterfaceLabel!
    @IBOutlet weak var accelerometerZLabel: WKInterfaceLabel!
    
    let motion = CMMotionManager()
    
    func setLabel(label: WKInterfaceLabel, datum: Double) -> Void {
        var datumToWriteToLabel: Double;
        var labelFormat: String;
        var labelTextColor: UIColor;
        
        if datum >= 0 {
            datumToWriteToLabel = datum;
            labelFormat = "+%.6f"
            labelTextColor = UIColor.white;
        } else {
            // Make it positive
            datumToWriteToLabel = -1 * datum;
            labelFormat = "-%.6f"
            labelTextColor = UIColor.gray;
        }
        
        label.setTextColor(labelTextColor)
        label.setText(String(format: labelFormat, datumToWriteToLabel))
    }
    
    func startDeviceMotion() {
        
        var timeSeriesData = [[Double]]()
        
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            motion.startDeviceMotionUpdates(to: OperationQueue.main) { (motionUpdate: CMDeviceMotion?, error: Error?) in
                
                let gravityData: CMAcceleration = motionUpdate!.gravity
                self.setLabel(label: self.accelerometerXLabel, datum: gravityData.x)
                self.setLabel(label: self.accelerometerYLabel, datum: gravityData.y)
                self.setLabel(label: self.accelerometerZLabel, datum: gravityData.z)
                
                timeSeriesData[1].append(gravityData.x)
                timeSeriesData[2].append(gravityData.y)
                timeSeriesData[3].append(gravityData.z)
                
                print(timeSeriesData)
            }
            
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        startDeviceMotion()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        motion.stopDeviceMotionUpdates()
    }

}
