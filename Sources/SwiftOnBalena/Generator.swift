//
//  Generator.swift
//  SwiftOnBalena
//
//  Created by Will Lisac on 4/29/19.
//

import Files
import Foundation
import Version
import MarkdownGenerator

public class Generator {
    public init() { }
    
    public func generateDeviceDockerfiles() throws {
        let architectureFilter = ImageDescriptionFilter(baseType: .architecture)
        
        let imageDescriptions = try ImageDescription.imageDescriptions(for: architectureFilter)
        
        try imageDescriptions.forEach {
            try generateDeviceDockerfiles(from: $0)
        }
        
        try generateDockerImageMatrix()
    }
    
    func generateDeviceDockerfiles(from imageDescription: ImageDescription) throws {
        guard case let .architecture(architecture) = imageDescription.base else {
            throw GeneratorError.invalidBaseType(file: try imageDescription.file().path)
        }
        
        let devices = Device.devices(with: architecture)
        
        try devices.forEach { device in
            try generateDockerfile(for: device, from: imageDescription)
        }
    }
    
    func generateDockerfile(for device: Device, from architectureImageDescription: ImageDescription) throws {
        guard case .architecture(_) = architectureImageDescription.base else {
            throw GeneratorError.invalidBaseType(file: try architectureImageDescription.file().path)
        }
        
        var deviceImageDescription = architectureImageDescription
        deviceImageDescription.base = .device(device)
        
        let architectureTagPrefix = "# \(architectureImageDescription.dockerTag)\n\nFROM \(architectureImageDescription.balenaFromDockerTag)\n"
        
        let deviceTagPrefix = "# Autogenerated device Dockerfile based on architecture Dockerfile: \(architectureImageDescription.dockerTag)\n\n# \(deviceImageDescription.dockerTag)\n\nFROM \(deviceImageDescription.balenaFromDockerTag)\n"
        
        let architectureDockerfileContent = try architectureImageDescription.file().readAsString()
        
        guard architectureDockerfileContent.hasPrefix(architectureTagPrefix),
            let architectureTagRange = architectureDockerfileContent.range(of: architectureTagPrefix) else {
                throw GeneratorError.invalidTagPrefix(file: try architectureImageDescription.file().path)
        }
        
        let deviceDockerfileContent = architectureDockerfileContent.replacingOccurrences(of: architectureTagPrefix,
                                                                                         with: deviceTagPrefix,
                                                                                         options: [],
                                                                                         range: architectureTagRange)
        
        try deviceImageDescription.file(createIfNeeded: true).write(string: deviceDockerfileContent)
        
        print("Generated \(deviceImageDescription.dockerTag) from \(architectureImageDescription.dockerTag)")
    }
    
    public func generateDockerImageMatrix() throws {
        let imageDescriptions = try ImageDescription.allImageDescriptions()
        
        let groupedByMajorVersion = try Dictionary(grouping: imageDescriptions) { (imageDescription) -> Int in
            let versionString = imageDescription.swiftVersion
            
            guard let semver = Version(tolerant: imageDescription.swiftVersion) else {
                throw GeneratorError.invalidVersion(versionString)
            }
            
            return semver.major
        }
        
        var markdown = [MarkdownConvertible]()
        
        groupedByMajorVersion.keys.sorted(by: >).forEach { major in
            let deviceTableData: [[String]] = groupedByMajorVersion[major]!.compactMap {
                guard case let .device(device) = $0.base else { return nil }
                return [
                    device.description,
                    "\($0.operatingSystem.name) \($0.operatingSystem.version)".capitalized,
                    $0.swiftVersion,
                    "`\($0.dockerTag)`"
                ]
            }
            
            let architectureTableData: [[String]] = groupedByMajorVersion[major]!.compactMap {
                guard case let .architecture(architecture) = $0.base else { return nil }
                return [
                    architecture.description,
                    "\($0.operatingSystem.name) \($0.operatingSystem.version)".capitalized,
                    $0.swiftVersion,
                    "`\($0.dockerTag)`"
                ]
            }
            
            let deviceTable = MarkdownTable(headers: ["Device", "OS", "Swift", "Image"], data: deviceTableData)
            
            let genericTable = MarkdownTable(headers: ["Architecture", "OS", "Swift", "Image"], data: architectureTableData)
            
            markdown.append(deviceTable)
            markdown.append(genericTable)
        }
        
        print(markdown.markdown)
    }
}

public enum GeneratorError: Error, CustomStringConvertible {
    case invalidBaseType(file: String)
    case invalidTagPrefix(file: String)
    case invalidVersion(String)
    
    public var description: String {
        switch self {
        case .invalidBaseType(let file):
            return "Generator error: Invalid base type for \(file)"
        case .invalidTagPrefix(let file):
            return "Generator error: Invalid tag prefix for \(file)"
        case .invalidVersion(let version):
            return "Generator error: Invalid version \(version)"
        }
    }
}