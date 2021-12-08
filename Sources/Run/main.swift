import Commander
import Foundation
import SwiftOnBalena

var builder: Builder?

enum BuildCommandError: Error, CustomStringConvertible {
    case invalidBaseType(String)
    
    var description: String {
        switch self {
        case .invalidBaseType(let type):
            return "Invalid base type: \(type)"
        }
    }
}

// MARK: - Arg Helpers

func imageDescriptionFilterFromArgs(osName: String = "",
                                    osVersion: String = "",
                                    swiftVersion: String = "",
                                    baseType: String = "",
                                    baseName: String = "",
                                    buildVariant: String = "") throws -> ImageDescriptionFilter {
    let baseTypeEnumValue: ImageDescriptionFilter.BaseType?
    
    if baseType.isEmpty {
        baseTypeEnumValue = nil
    } else {
        baseTypeEnumValue = ImageDescriptionFilter.BaseType(rawValue: baseType)
        guard baseTypeEnumValue != nil else {
            throw BuildCommandError.invalidBaseType(baseType)
        }
    }
    
    let filter = ImageDescriptionFilter(operatingSystemName: osName.isEmpty ? nil : osName,
                                        operatingSystemVersion: osVersion.isEmpty ? nil : osVersion,
                                        swiftVersion: swiftVersion.isEmpty ? nil : swiftVersion,
                                        baseType: baseTypeEnumValue,
                                        baseName: baseName.isEmpty ? nil : baseName,
                                        buildVariant: buildVariant.isEmpty ? nil : buildVariant)
    
    return filter
}

// MARK: - Commands

let buildCommand = command(
    Option("osName", default: ""),
    Option("osVersion", default: ""),
    Option("swiftVersion", default: ""),
    Option("baseType", default: "", description: "architecture | device"),
    Option("baseName", default: "", description: "architecture name | device name"),
    Option("buildVariant", default: "", description: "build | run")
) { osName, osVersion, swiftVersion, baseType, baseName, buildVariant in
    let filter = try imageDescriptionFilterFromArgs(osName: osName,
                                                    osVersion: osVersion,
                                                    swiftVersion: swiftVersion,
                                                    baseType: baseType,
                                                    baseName: baseName,
                                                    buildVariant: buildVariant)
    builder = Builder()
    try builder?.buildDockerImages(filter: filter)
}

let testCommand = command(
    Option("osName", default: ""),
    Option("osVersion", default: ""),
    Option("swiftVersion", default: ""),
    Option("baseType", default: "", description: "architecture | device"),
    Option("baseName", default: "", description: "architecture name | device name"),
    Option("buildVariant", default: "", description: "build | run")
) { osName, osVersion, swiftVersion, baseType, baseName, buildVariant in
    let filter = try imageDescriptionFilterFromArgs(osName: osName,
                                                    osVersion: osVersion,
                                                    swiftVersion: swiftVersion,
                                                    baseType: baseType,
                                                    baseName: baseName,
                                                    buildVariant: buildVariant)
    builder = Builder()
    try builder?.testDockerImages(filter: filter)
}

let pushCommand = command(
    Option("osName", default: ""),
    Option("osVersion", default: ""),
    Option("swiftVersion", default: ""),
    Option("baseType", default: "", description: "architecture | device"),
    Option("baseName", default: "", description: "architecture name | device name"),
    Option("buildVariant", default: "", description: "build | run")
) { osName, osVersion, swiftVersion, baseType, baseName, buildVariant in
    let filter = try imageDescriptionFilterFromArgs(osName: osName,
                                                    osVersion: osVersion,
                                                    swiftVersion: swiftVersion,
                                                    baseType: baseType,
                                                    baseName: baseName,
                                                    buildVariant: buildVariant)
    builder = Builder()
    try builder?.pushDockerImages(filter: filter)
}

let generateCommand = command(
    Option("swiftVersion", default: "")
) { swiftVersion in
    let filter = try imageDescriptionFilterFromArgs(swiftVersion: swiftVersion)
    
    let generator = Generator()
    try generator.generateDeviceDockerfiles(filter: filter)
}

let tagDefaultImages = command(
    Option("osName", default: ""),
    Option("osVersion", default: ""),
    Option("swiftVersion", default: ""),
    Option("baseType", default: "", description: "architecture | device"),
    Option("baseName", default: "", description: "architecture name | device name"),
    Option("buildVariant", default: "", description: "build | run")
) { osName, osVersion, swiftVersion, baseType, baseName, buildVariant in
    let filter = try imageDescriptionFilterFromArgs(osName: osName,
                                                osVersion: osVersion,
                                                swiftVersion: swiftVersion,
                                                baseType: baseType,
                                                baseName: baseName,
                                                buildVariant: buildVariant)
    builder = Builder()
    try builder?.tagDefaultDockerImages(filter: filter)
}

let pushDefaultImages = command(
    Option("osName", default: ""),
    Option("osVersion", default: ""),
    Option("swiftVersion", default: ""),
    Option("baseType", default: "", description: "architecture | device"),
    Option("baseName", default: "", description: "architecture name | device name"),
    Option("buildVariant", default: "", description: "build | run")
) { osName, osVersion, swiftVersion, baseType, baseName, buildVariant in
    let filter = try imageDescriptionFilterFromArgs(osName: osName,
                                                    osVersion: osVersion,
                                                    swiftVersion: swiftVersion,
                                                    baseType: baseType,
                                                    baseName: baseName,
                                                    buildVariant: buildVariant)
    builder = Builder()
    try builder?.pushDefaultDockerImages(filter: filter)
}

let main = Group {
    $0.addCommand("build", "builds images", buildCommand)
    $0.addCommand("test", "tests images", testCommand)
    $0.addCommand("push", "push images", pushCommand)
    $0.addCommand("tag-default-images", "tags default device images", tagDefaultImages)
    $0.addCommand("push-default-images", "push default device images", pushDefaultImages)
    $0.addCommand("generate", "generate device images", generateCommand)
}

signal(SIGINT, SIG_IGN) // prevent termination

let sigintSource = DispatchSource.makeSignalSource(signal: SIGINT, queue: .main)

sigintSource.setEventHandler {
    print()
    builder?.interrupt()
    exit(0)
}

sigintSource.resume()

main.run()
