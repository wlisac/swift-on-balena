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

let buildCommand = command(
    Option("osName", default: ""),
    Option("osVersion", default: ""),
    Option("swiftVersion", default: ""),
    Option("baseType", default: "", description: "architecture | device"),
    Option("baseName", default: "", description: "architecture name | device name")
) { osName, osVersion, swiftVersion, baseType, baseName in
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
                                        baseName: baseName.isEmpty ? nil : baseName)
    
    builder = Builder()
    try builder?.build(filter: filter)
}

let generateCommand = command {
    let generator = Generator()
    try generator.generateDeviceDockerfiles()
}

let main = Group {
    $0.addCommand("build", "builds images", buildCommand)
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
