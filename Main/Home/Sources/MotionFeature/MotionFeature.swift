//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/08.
//

import CoreMotion

final class MotionFeature: NSObject {
    
    let motionManager = CMMotionManager()
    
    func start() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motion:CMDeviceMotion?, error:Error?) in
                self.updateMotionData(deviceMotion: motion!)
            })
        }
    }
    
    
    func updateMotionData(deviceMotion: CMDeviceMotion) {
        print(deviceMotion.userAcceleration.x)
        print(deviceMotion.userAcceleration.y)
        print(deviceMotion.userAcceleration.z)
        print(deviceMotion.attitude.pitch)
        print(deviceMotion.attitude.yaw)
        print(deviceMotion.attitude.roll)
        print(deviceMotion.gravity.x)
        print(deviceMotion.gravity.y)
        print(deviceMotion.gravity.z)
        print(deviceMotion.sensorLocation)
        print(deviceMotion.heading)
        print(deviceMotion.magneticField)
    }
    
    func startGyro() {
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: OperationQueue.current!) { gyro, error in
                self.updateGyro(gyro!)
            }
        }
    }
    
    func updateGyro(_ gyro: CMGyroData) {
        print(gyro.rotationRate.x)
        print(gyro.rotationRate.y)
        print(gyro.rotationRate.z)
    }
}
