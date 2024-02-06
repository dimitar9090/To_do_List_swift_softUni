//
//  CoreMotionManager.swift
//  ToDoList
//
//  Created by Ivan Chavdarov Ivanov on 16.01.24.
//

import Foundation
import CoreMotion

protocol CoreMotionManagerDelegate: AnyObject {
    func didDetectShake()
}

class CoreMotionManager {
    private let motionManager = CMMotionManager()
    weak var delegate: CoreMotionManagerDelegate?
    
    func startAccelerometerUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { data, error in
                if let acceleration = data?.acceleration {
                    let shakeThreshold = 1.5
                    let totalAcceleration = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))
                    
                    if totalAcceleration >= shakeThreshold {
                        self.delegate?.didDetectShake()
                    }
                }
            }
        }
    }
    
    func stopAccelerometerUpdates() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
}
