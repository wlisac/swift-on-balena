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
    
    public func build(filter: ImageDescriptionFilter) throws {
        let allFiles = try Folder.current.subfolder(named: "Dockerfiles").makeFileSequence(recursive: true, includeHidden: false)
        
        let imageDescriptions = allFiles.compactMap { ImageDescription(file: $0) }
        
        let matchingImageDescriptions = imageDescriptions.filter { filter.includes($0) }
        
        try matchingImageDescriptions.forEach {
            try buildDockerImage(from: $0)
        }
        
        matchingImageDescriptions.forEach {
            print("Tagged: \($0.dockerTag)")
        }

        try matchingImageDescriptions.forEach {
            try pushDockerImage(from: $0)
        }

        matchingImageDescriptions.forEach {
            print("Pushed: \($0.dockerTag)")
        }
    }
    
    public func buildDockerImage(from imageDescription: ImageDescription) throws {
        print("Building docker image: \(imageDescription.dockerTag)")
        
        let file = imageDescription.file
        
        var context = CustomContext(main)
        context.currentdirectory = file.parent!.path // swiftlint:disable:this force_unwrapping
        let command = context.runAsyncAndPrint("docker", "build", "-t", imageDescription.dockerTag, "-f", file.name, ".")
        currentCommand = command
        try command.finish()
    }
    
    public func pushDockerImage(from imageDescription: ImageDescription) throws {
        print("Pushing docker image: \(imageDescription.dockerTag)")
        
        let file = imageDescription.file
        
        var context = CustomContext(main)
        context.currentdirectory = file.parent!.path // swiftlint:disable:this force_unwrapping
        let command = context.runAsyncAndPrint("docker", "push", imageDescription.dockerTag)
        currentCommand = command
        try command.finish()
    }
    
    public func interrupt() {
        currentCommand?.interrupt()
    }
}
