//
//  ImageDescription.swift
//  SwiftOnBalena
//
//  Created by Will Lisac on 4/29/19.
//

import Files
import Foundation

public struct ImageDescription: Equatable {
    public let file: File
    public let operatingSystem: OperatingSystem
    public let swiftVersion: Version
    public let base: ImageBase
}

extension ImageDescription {
    var dockerTag: String {
        return "wlisac/\(base.name)-\(operatingSystem.name)-swift:\(swiftVersion)-\(operatingSystem.version)"
    }
}

extension ImageDescription {
    init?(file: File) {
        self.file = file
        
        guard let swiftVersionFolder = file.parent,
            let osVersionFolder = swiftVersionFolder.parent,
            let osNameFolder = osVersionFolder.parent,
            let baseNameFolder = osNameFolder.parent,
            let baseTypeFolder = baseNameFolder.parent else {
                return nil
        }
        
        switch baseTypeFolder.name {
        case "arch-base":
            guard let architecture = Architecture(rawValue: baseNameFolder.name) else { return nil }
            self.base = ImageBase.architecture(architecture)
        case "device-base":
            guard let device = Device(rawValue: baseNameFolder.name) else { return nil }
            self.base = ImageBase.device(device)
        default:
            return nil
        }
        
        guard let operatingSystem = OperatingSystem(name: osNameFolder.name, version: osVersionFolder.name) else {
            return nil
        }
        
        self.operatingSystem = operatingSystem
        
        guard !swiftVersionFolder.name.isEmpty else { return nil }
        
        self.swiftVersion = swiftVersionFolder.name
    }
}

public typealias Version = String

public struct OperatingSystem: Equatable {
    public let name: String
    public let version: Version
    
    public init?(name: String, version: Version) {
        guard !name.isEmpty && !version.isEmpty else { return nil }
        self.name = name
        self.version = version
    }
}

public enum Architecture: String, Equatable {
    case rpi
    case armv7hf
    case aarch64
}

public enum Device: String, Equatable {
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
}

public enum ImageBase: Equatable {
    case device(Device)
    case architecture(Architecture)
    
    var name: String {
        switch self {
        case let .device(device):
            return device.rawValue
        case let .architecture(architecture):
            return architecture.rawValue
        }
    }
}
