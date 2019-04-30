import Commander
import Foundation
import SwiftOnBalena

var builder: Builder?

let buildCommand = command(
    Option("osName", default: ""),
    Option("osVersion", default: ""),
    Option("swiftVersion", default: ""),
    Option("baseType", default: "", description: "architecture | device"),
    Option("baseName", default: "", description: "architecture name | device name")
) { osName, osVersion, swiftVersion, baseType, baseName in
    let filter = ImageDescriptionFilter(operatingSystemName: osName.isEmpty ? nil : osName,
                                        operatingSystemVersion: osVersion.isEmpty ? nil : osVersion,
                                        swiftVersion: swiftVersion.isEmpty ? nil : swiftVersion,
                                        baseType: baseType.isEmpty ? nil : baseType,
                                        baseName: baseName.isEmpty ? nil : baseName)
    builder = Builder()
    try builder?.build(filter: filter)
}

let main = Group {
    $0.addCommand("build", "builds images", buildCommand)
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
