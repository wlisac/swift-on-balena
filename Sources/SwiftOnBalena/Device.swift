//
//  Device.swift
//  SwiftOnBalena
//
//  Created by Will Lisac on 4/29/19.
//

import Foundation

public enum Architecture: String, Equatable, CustomStringConvertible {
    case rpi
    case armv7hf
    case aarch64
    
    public var description: String {
        switch self {
        case .rpi:
            return "armv6"
        case .armv7hf:
            return "armv7hf"
        case .aarch64:
            return "aarch64"
        }
    }
}

public enum Device: String, Equatable, CaseIterable, CustomStringConvertible {
    case raspberryPi = "raspberry-pi"
    case raspberryPi2 = "raspberry-pi2"
    case raspberryPi3 = "raspberrypi3"
    case raspberryPi3_64 = "raspberrypi3-64"
    case raspberryPi4_64 = "raspberrypi4-64"
    
    case genericARMv7aHF = "generic-armv7ahf"
    case genericAArch64 = "generic-aarch64"
    
    public var architecture: Architecture {
        switch self {
        case .raspberryPi:
            return .rpi
        case .raspberryPi2:
            return .armv7hf
        case .raspberryPi3:
            return .armv7hf
        case .raspberryPi3_64:
            return .aarch64
        case .raspberryPi4_64:
            return .aarch64
        case .genericARMv7aHF:
            return .armv7hf
        case .genericAArch64:
            return .aarch64
        }
    }
    
    public var description: String {
        switch self {
        case .raspberryPi:
            return "Raspberry Pi (v1 or Zero)"
        case .raspberryPi2:
            return "Raspberry Pi 2"
        case .raspberryPi3:
            return "Raspberry Pi 3"
        case .raspberryPi3_64:
            return "Raspberry Pi 3 (using 64 bit OS)"
        case .raspberryPi4_64:
            return "Raspberry Pi 4 (using 64 bit OS)"
        case .genericARMv7aHF:
            return "Generic ARMv7-a HF"
        case .genericAArch64:
            return "Generic AARCH64 (ARMv8)"
        }
    }
    
    static func devices(with architecture: Architecture) -> [Device] {
        return allCases.filter { $0.architecture == architecture }
    }
}
