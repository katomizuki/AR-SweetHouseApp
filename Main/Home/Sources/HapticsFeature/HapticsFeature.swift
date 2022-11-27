//
//  File.swift
//  
//
//  Created by ミズキ on 2022/11/27.
//

import CoreHaptics

struct HapticsFeature {
    func supportedHaptics() -> Bool {
        return CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
    
    func eventHaptics() {
        // CoreHapticsをする
        guard let  hapticEngine = try? CHHapticEngine() else { return }
        do {
            try hapticEngine.start()
        } catch {
            print(error.localizedDescription)
        }
               
        let pattern = self.makeHapticPattern()
        guard let player = try? hapticEngine.makePlayer(with: pattern) else { return }
               
        do {
           try player.start(atTime: CHHapticTimeImmediate)
        } catch {
           print(error.localizedDescription)
        }
    }
    
    private func makeHapticPattern() -> CHHapticPattern {
        let audioEvent = CHHapticEvent(eventType: .audioContinuous,
                                       parameters: [
                    CHHapticEventParameter(parameterID: .audioPitch,
                                           value: -0.15),
                    CHHapticEventParameter(parameterID: .audioVolume,
                                           value: 0.5),
                    CHHapticEventParameter(parameterID: .decayTime,
                                           value: 0),
                    CHHapticEventParameter(parameterID: .sustained,
                                           value: 0)
                ],
                                       relativeTime: 0)
        let hapticEvent = CHHapticEvent(eventType: .hapticTransient,
                                        parameters: [
                                                CHHapticEventParameter(parameterID: .hapticIntensity,
                                                                       value: 1),
                                                CHHapticEventParameter(parameterID: .hapticIntensity,
                                                                       value: 1)
                                               ],
                                        relativeTime: 0)
                let pattern = try! CHHapticPattern(events: [audioEvent, hapticEvent],
                                                   parameters: [])
                return pattern
    }
}
