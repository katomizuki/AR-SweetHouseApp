//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/08.
//

import CoreMotion
import ComposableArchitecture

extension DependencyValues{
    public var motionFeature: MotionFeature {
        get { self[MotionFeature.self] }
        set { self[MotionFeature.self] = newValue }
    }
}

extension MotionFeature: DependencyKey {
    public static var liveValue: MotionFeature {
        return MotionFeature()
    }
}

enum MotionError: Error {
    case notSupported
    case noData
}

final public class MotionFeature: NSObject {
    
    let motionManager = CMMotionManager()
    
    private func getDeviceMotion(completion: @escaping(Result<CMDeviceMotion, MotionError>) -> Void) {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!,
                                                   withHandler: { (motion: CMDeviceMotion?,
                                                                   error: Error?) in
                guard let motion = motion else {
                    completion(.failure(MotionError.noData))
                    return
                }
                completion(.success(motion))
            })
        } else {
            completion(.failure(MotionError.notSupported))
        }
    }
    
    public func getDeviceMotion() async throws -> CMDeviceMotion {
        try await withCheckedThrowingContinuation({ continuation in
            self.getDeviceMotion { result in
                switch result {
                case .success(let deviceMotion):
                    continuation.resume(returning: deviceMotion)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }

    private func getGryro(completion: @escaping(Result<CMGyroData, MotionError>) -> Void) {
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: OperationQueue.current!) { gyro, _ in
                guard let gyro = gyro else {
                    completion(.failure(.noData))
                    return
                }
                completion(.success(gyro))
            }
        } else {
            completion(.failure(.notSupported))
        }
    }
    
    public func getGryro() async throws -> CMGyroData {
        try await withCheckedThrowingContinuation({ continuation in
            self.getGryro { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }
}
