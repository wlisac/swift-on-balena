//
//  ImageDescriptionFilter.swift
//  SwiftOnBalena
//
//  Created by Will Lisac on 4/29/19.
//

import Foundation

public struct ImageDescriptionFilter: Equatable {
    public enum BaseType: String {
        case device
        case architecture
    }
    
    public var operatingSystemName: String?
    public var operatingSystemVersion: String?
    public var swiftVersion: String?
    public var baseType: BaseType?
    public var baseName: String?
    
    public init(operatingSystemName: String? = nil,
                operatingSystemVersion: String? = nil,
                swiftVersion: String? = nil,
                baseType: BaseType? = nil,
                baseName: String? = nil) {
        self.operatingSystemName = operatingSystemName
        self.operatingSystemVersion = operatingSystemVersion
        self.swiftVersion = swiftVersion
        self.baseType = baseType
        self.baseName = baseName
    }
}

extension ImageDescriptionFilter {
    // swiftlint:disable:next cyclomatic_complexity
    func includes(_ imageDescription: ImageDescription) -> Bool {
        guard operatingSystemName == nil || operatingSystemName == imageDescription.operatingSystem.name else { return false }
        
        guard operatingSystemVersion == nil || operatingSystemVersion == imageDescription.operatingSystem.version else { return false }
        
        guard swiftVersion == nil || swiftVersion == imageDescription.swiftVersion else { return false }
        
        if let baseType = baseType {
            switch baseType {
            case .device:
                guard case .device(_) = imageDescription.base else { return false }
            case .architecture:
                guard case .architecture(_) = imageDescription.base else { return false }
            }
        }
        
        if let baseName = baseName {
            switch imageDescription.base {
            case .architecture(let architecture):
                guard architecture.rawValue == baseName else { return false }
            case .device(let device):
                guard device.rawValue == baseName else { return false }
            }
        }
        
        return true
    }
}
