//
//  ImageDescription.swift
//  SwiftOnBalena
//
//  Created by Will Lisac on 4/29/19.
//

import Files
import Foundation

public struct ImageDescription: Equatable {
    public var operatingSystem: OperatingSystem
    public var swiftVersion: String
    public var base: ImageBase
    public var buildVariant: BuildVariant
}

extension ImageDescription {
    static func dockerfilesFolder() throws -> Folder {
        return try Folder.current.subfolder(named: "Dockerfiles")
    }
    
    static func allImageDescriptions() throws -> [ImageDescription] {
        let allFiles = try dockerfilesFolder().makeFileSequence(recursive: true, includeHidden: false)
        let allImageDescriptions = allFiles.compactMap { ImageDescription(file: $0) }
        return allImageDescriptions
    }
    
    static func imageDescriptions(for filter: ImageDescriptionFilter) throws -> [ImageDescription] {
        let filtered = try allImageDescriptions().filter { filter.includes($0) }
        return filtered
    }
}

extension ImageDescription {
    var dockerNamespace: String {
        return "wlisac"
    }
    
    var dockerImageName: String {
        return "\(base.name)-\(operatingSystem.name)-swift"
    }
    
    var dockerTagName: String {
        return "\(swiftVersion)-\(operatingSystem.version)-\(buildVariant.rawValue)"
    }
    
    var dockerTag: String {
        return "\(dockerNamespace)/\(dockerImageName):\(dockerTagName)"
    }
    
    var defaultOSDockerImageName: String {
        return "\(base.name)-swift"
    }
    
    var defaultOSDockerTagName: String {
        return "\(swiftVersion)"
    }
    
    var defaultOSDockerTag: String {
        return "\(dockerNamespace)/\(defaultOSDockerImageName):\(defaultOSDockerTagName)-\(buildVariant.rawValue)"
    }
    
    var balenaFromDockerTag: String {
        return "balenalib/\(base.name)-\(operatingSystem.name):\(operatingSystem.version)"
    }
    
    func folder(createIfNeeded: Bool = false) throws -> Folder {
        let folder = try ImageDescription.dockerfilesFolder()
        
        let baseTypeFolderName: String
        let baseFolderName: String
        
        switch base {
        case .architecture(let architecture):
            baseTypeFolderName = "architecture-base"
            baseFolderName = architecture.rawValue
        case .device(let device):
            baseTypeFolderName = "device-base"
            baseFolderName = device.rawValue
        }
        
        if createIfNeeded {
            return try folder.createSubfolderIfNeeded(withName: baseTypeFolderName)
                .createSubfolderIfNeeded(withName: baseFolderName)
                .createSubfolderIfNeeded(withName: operatingSystem.name)
                .createSubfolderIfNeeded(withName: operatingSystem.version)
                .createSubfolderIfNeeded(withName: swiftVersion)
                .createSubfolderIfNeeded(withName: buildVariant.rawValue)
        } else {
            return try folder.createSubfolderIfNeeded(withName: baseTypeFolderName)
                .subfolder(named: baseFolderName)
                .subfolder(named: operatingSystem.name)
                .subfolder(named: operatingSystem.version)
                .subfolder(named: swiftVersion)
                .subfolder(named: buildVariant.rawValue)
        }
    }
    
    func file(createIfNeeded: Bool = false) throws -> File {
        if createIfNeeded {
            return try folder(createIfNeeded: createIfNeeded).createFileIfNeeded(withName: "Dockerfile")
        } else {
            return try folder(createIfNeeded: createIfNeeded).file(named: "Dockerfile")
        }
    }
    
    var isDeviceBase: Bool {
        if case .device = base {
            return true
        }
        return false
    }
}

extension ImageDescription {
    init?(file: File) {
        guard file.name == "Dockerfile" else { return nil }
        
        guard let buildVariantFolder = file.parent,
            let swiftVersionFolder = buildVariantFolder.parent,
            let osVersionFolder = swiftVersionFolder.parent,
            let osNameFolder = osVersionFolder.parent,
            let baseNameFolder = osNameFolder.parent,
            let baseTypeFolder = baseNameFolder.parent else {
                return nil
        }
        
        switch baseTypeFolder.name {
        case "architecture-base":
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
        
        guard let buildVariant = BuildVariant(rawValue: buildVariantFolder.name) else {
            return nil
        }
        
        self.buildVariant = buildVariant
    }
}

public struct OperatingSystem: Equatable {
    public var name: String
    public var version: String
    
    public init?(name: String, version: String) {
        guard !name.isEmpty && !version.isEmpty else { return nil }
        self.name = name
        self.version = version
    }
}

public enum ImageBase: Hashable, CustomStringConvertible {
    case device(Device)
    case architecture(Architecture)
    
    public var name: String {
        switch self {
        case .device(let device):
            return device.rawValue
        case .architecture(let architecture):
            return architecture.rawValue
        }
    }
    
    public var description: String {
        switch self {
        case .device(let device):
            return device.description
        case .architecture(let architecture):
            return architecture.description
        }
    }
    
    var architecture: Architecture {
        switch self {
        case .device(let device):
            return device.architecture
        case .architecture(let architecture):
            return architecture
        }
    }
}

public enum BuildVariant: String {
    case build
    case run
}
