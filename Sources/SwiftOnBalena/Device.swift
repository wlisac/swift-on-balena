//
//  Device.swift
//  SwiftOnBalena
//
//  Created by Will Lisac on 4/29/19.
//

import Foundation

public enum Architecture: String, Equatable {
    case rpi
    case armv7hf
    case aarch64
}

public enum Device: String, Equatable, CaseIterable {
    case raspberryPi = "raspberry-pi"
    case raspberryPi2 = "raspberry-pi2"
    case raspberryPi3 = "raspberrypi3"
    case raspberryPi364 = "raspberrypi3-64"
    
    public var architecture: Architecture {
        switch self {
        case .raspberryPi:
            return .rpi
        case .raspberryPi2:
            return .armv7hf
        case .raspberryPi3:
            return .armv7hf
        case .raspberryPi364:
            return .aarch64
        }
    }
    
    static func devices(with architecture: Architecture) -> [Device] {
        return allCases.filter { $0.architecture == architecture }
    }
}
