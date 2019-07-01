//
//  Builder.swift
//  SwiftOnBalena
//
//  Created by Will Lisac on 4/25/19.
//

import Files
import Foundation
import SwiftShell

public class Builder {
    var currentCommand: PrintedAsyncCommand?
    
    public init() { }
    
    public func buildDockerImages(filter: ImageDescriptionFilter) throws {
        print("Build Filter: \(filter)\n")
        
        let imageDescriptions = try ImageDescription.imageDescriptions(for: filter)
        
        print("Build Manifest:")
        imageDescriptions.forEach {
            print("    - \($0.dockerTag)")
        }
        
        print()
        
        try imageDescriptions.forEach {
            try buildDockerImage(from: $0)
        }
        
        imageDescriptions.forEach {
            print("Tagged: \($0.dockerTag)")
        }
    }
    
    public func pushDockerImages(filter: ImageDescriptionFilter) throws {
        print("Push Filter: \(filter)\n")
        
        let imageDescriptions = try ImageDescription.imageDescriptions(for: filter)
        
        print("Push Manifest:")
        imageDescriptions.forEach {
            print("    - \($0.dockerTag)")
        }
        
        print()
        
        try imageDescriptions.forEach {
            try pushDockerImage(from: $0)
        }
        
        imageDescriptions.forEach {
            print("Pushed: \($0.dockerTag)")
        }
    }
    
    public func testDockerImages(filter: ImageDescriptionFilter) throws {
        print("Test Filter: \(filter)\n")
        
        let imageDescriptions = try ImageDescription.imageDescriptions(for: filter)
        
        print("Test Manifest:")
        imageDescriptions.forEach {
            print("    - \($0.dockerTag)")
        }
        
        print()
        
        try imageDescriptions.forEach {
            try testDockerImage(from: $0)
        }
        
        imageDescriptions.forEach {
            print("Tested: \($0.dockerTag)")
        }
    }
    
    func buildDockerImage(from imageDescription: ImageDescription) throws {
        print("Building docker image: \(imageDescription.dockerTag)")
        
        let file = try imageDescription.file()
        
        var context = CustomContext(main)
        context.currentdirectory = try imageDescription.folder().path
        let command = context.runAsyncAndPrint("docker", "build", "--pull", "-t", imageDescription.dockerTag, "-f", file.name, ".")
        currentCommand = command
        try command.finish()
        
        if case .architecture(_) = imageDescription.base {
//            try testDockerImage(from: imageDescription)
//            try testDockerImageOnRemoteHost(from: imageDescription)
        }
    }
    
    func testDockerImage(from imageDescription: ImageDescription) throws {
        // TODO: Implement test suite for run variant docker images
        guard imageDescription.buildVariant == .build else {
            print("Skipping test suite for '\(imageDescription.buildVariant.rawValue)' docker image: \(imageDescription.dockerTag)")
            return
        }
        
        print("Starting test suite for docker image: \(imageDescription.dockerTag)")
        
        guard let testSuiteFolder = try Folder.current.parent?.subfolder(named: "SwiftOnBalenaTestSuite") else {
            throw BuilderError.missingTestSuite
        }
        
        var context = CustomContext(main)
        context.currentdirectory = testSuiteFolder.path
        
        let dockerTag = "\(imageDescription.dockerNamespace)/swift-on-balena-test-suite-\(imageDescription.dockerImageName):\(imageDescription.dockerTagName)"
        
        print("Build test docker image: \(dockerTag)")
        
        let command = context.runAsyncAndPrint("docker",
                                               "build",
                                               "-t",
                                               dockerTag,
                                               "--build-arg",
                                               "BASE_IMAGE=\(imageDescription.dockerTag)",
                                               ".")
        currentCommand = command
        try command.finish()
        
        // I was noticing that docker would often hang when attempting to run an image it just built
        // Adding a little sleep appears to help resolve the issue (the best kind of workaround…)
//        sleep(3)
//
//        print("Running test docker image: \(dockerTag)")
//
//        let runCommand = context.runAsyncAndPrint("docker",
//                                                  "run",
//                                                  "--rm",
//                                                  dockerTag)
//        currentCommand = runCommand
//        try runCommand.finish()
    }
    
    func removeAllImages(withPattern pattern: String, onRemoteHost host: String) throws {
        let context = CustomContext(main)
        let command = context.runAsyncAndPrint(bash: "docker --host \(host) rmi $(docker --host \(host) images --format '{{.Repository}}:{{.Tag}}' | grep '\(pattern)')")
        currentCommand = command
        try command.finish()
    }
    
    func testDockerImageOnRemoteHost(from imageDescription: ImageDescription) throws {
        print("Starting test suite for docker image: \(imageDescription.dockerTag)")
        
        guard let testSuiteFolder = try Folder.current.parent?.subfolder(named: "SwiftOnBalenaTestSuite") else {
            throw BuilderError.missingTestSuite
        }
        
        let remoteHost = DockerHost.host(for: imageDescription.base.architecture)
        
        var context = CustomContext(main)
        context.currentdirectory = testSuiteFolder.path
        
        let transferCommand = context.runAsyncAndPrint(bash: "docker save \(imageDescription.dockerTag) | docker --host \(remoteHost) load")
        currentCommand = transferCommand
        try transferCommand.finish()
        
        let testDockerTag = "\(imageDescription.dockerNamespace)/swift-on-balena-test-suite-\(imageDescription.dockerImageName):\(imageDescription.dockerTagName)"
        
        print("Building test docker image: \(testDockerTag)")
        
        let buildCommand = context.runAsyncAndPrint("docker",
                                                    "--host",
                                                    remoteHost,
                                                    "build",
                                                    "-t",
                                                    testDockerTag,
                                                    "--build-arg",
                                                    "BASE_IMAGE=\(imageDescription.dockerTag)",
                                                    ".")
        
        currentCommand = buildCommand
        try buildCommand.finish()
        
//        print("Running test docker image: \(testDockerTag)")
//
//        let runCommand = context.runAsyncAndPrint("docker",
//                                                  "--host",
//                                                  remoteHost,
//                                                  "run",
//                                                  "--rm",
//                                                  testDockerTag)
//        currentCommand = runCommand
//        try runCommand.finish()
        
        try removeAllImages(withPattern: imageDescription.dockerNamespace, onRemoteHost: remoteHost)
    }
    
    func pushDockerImage(from imageDescription: ImageDescription) throws {
        print("Pushing docker image: \(imageDescription.dockerTag)")
        
        let context = CustomContext(main)
        let command = context.runAsyncAndPrint("docker", "push", imageDescription.dockerTag)
        currentCommand = command
        try command.finish()
    }
    
    public func tagDefaultDeviceDockerImages(filter: ImageDescriptionFilter) throws {
        let defaultImages = try defaultDeviceDockerImageDescriptions(filter: filter)
        
        let context = CustomContext(main)
        
        defaultImages.forEach { imageDescription in
            let tagCommand = context.runAsyncAndPrint(bash: "docker tag \(imageDescription.dockerTag) \(imageDescription.defaultOSDockerTag)")
            currentCommand = tagCommand
            do {
                try tagCommand.finish()
                print("Tagged \(imageDescription.dockerTag) as \(imageDescription.defaultOSDockerTag)")
            } catch {
                print("ERROR: Failed to tag \(imageDescription.defaultOSDockerTag). Skipping this tag.")
            }
        }
    }
    
    public func pushDefaultDeviceDockerImages(filter: ImageDescriptionFilter) throws {
        let defaultImages = try defaultDeviceDockerImageDescriptions(filter: filter)
        
        let context = CustomContext(main)
        
        print("Push Manifest")
        defaultImages.forEach { imageDescription in
            print("    - \(imageDescription.defaultOSDockerTag)")
        }
        print()
        
        var failedImages = [ImageDescription]()
        
        defaultImages.forEach { imageDescription in
            let tagCommand = context.runAsyncAndPrint(bash: "docker push \(imageDescription.defaultOSDockerTag)")
            currentCommand = tagCommand
            do {
                try tagCommand.finish()
                print("Pushed \(imageDescription.defaultOSDockerTag)")
            } catch {
                failedImages.append(imageDescription)
                print("ERROR: Failed to push \(imageDescription.defaultOSDockerTag). Skipping this tag.")
            }
        }
        
        if !failedImages.isEmpty {
            print("ERROR: Failed to push images:")
        }
        
        failedImages.forEach { imageDescription in
            print("    - \(imageDescription.defaultOSDockerTag).")
        }
    }
    
    func preferredOperatingSystems() -> [OperatingSystem] {
        return [
            OperatingSystem(name: "debian", version: "stretch")!,
            OperatingSystem(name: "ubuntu", version: "bionic")!,
            OperatingSystem(name: "ubuntu", version: "xenial")!
        ]
    }
    
    func defaultDeviceDockerImageDescriptions(filter: ImageDescriptionFilter) throws -> [ImageDescription] {
        let deviceImageDescriptions = try ImageDescription.imageDescriptions(for: filter).filter { $0.isDeviceBase }
        
        let groupedByVersion = Dictionary(grouping: deviceImageDescriptions) { $0.swiftVersion }
        
        var defaultImages = [ImageDescription]()
        
        groupedByVersion.forEach { _, imageDescriptions in
            let groupedByDevice = Dictionary(grouping: imageDescriptions) { $0.base }
            
            groupedByDevice.forEach { _, imageDescriptions in
                
                var defaultImage: ImageDescription?
                for os in preferredOperatingSystems() {
                    defaultImage = imageDescriptions.first(where: { $0.operatingSystem == os })
                    if let defaultImage = defaultImage {
                        defaultImages.append(defaultImage)
                        break
                    }
                }
                if defaultImage == nil {
                    let firstCandidate = imageDescriptions[0]
                    print("WARNING: Did not find default image for: \(firstCandidate.base) / \(firstCandidate.swiftVersion)")
                }
            }
        }
        
        defaultImages.forEach { imageDescription in
            if imageDescription.operatingSystem != preferredOperatingSystems()[0] {
                print("WARNING: Using fallback default image for: \(imageDescription.dockerTag) -> \(imageDescription.defaultOSDockerTag)")
            }
        }
        
        return defaultImages
    }
    
    public func interrupt() {
        currentCommand?.interrupt()
    }
}

enum BuilderError: Error, CustomStringConvertible {
    case missingTestSuite
    
    var description: String {
        switch self {
        case .missingTestSuite:
            return "Missing test suite"
        }
    }
}
