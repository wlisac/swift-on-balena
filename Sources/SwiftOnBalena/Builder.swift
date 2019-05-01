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
    
    public func build(filter: ImageDescriptionFilter, push: Bool = false) throws {
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
        
        if push {
            try imageDescriptions.forEach {
                try pushDockerImage(from: $0)
            }
            
            imageDescriptions.forEach {
                print("Pushed: \($0.dockerTag)")
            }
        }
    }
    
    func buildDockerImage(from imageDescription: ImageDescription) throws {
        print("Building docker image: \(imageDescription.dockerTag)")
        
        let file = try imageDescription.file()
        
        var context = CustomContext(main)
        context.currentdirectory = try imageDescription.folder().path
        let command = context.runAsyncAndPrint("docker", "build", "-t", imageDescription.dockerTag, "-f", file.name, ".")
        currentCommand = command
        try command.finish()
    }
    
    func pushDockerImage(from imageDescription: ImageDescription) throws {
        print("Pushing docker image: \(imageDescription.dockerTag)")
        
        let context = CustomContext(main)
        let command = context.runAsyncAndPrint("docker", "push", imageDescription.dockerTag)
        currentCommand = command
        try command.finish()
    }
    
    public func interrupt() {
        currentCommand?.interrupt()
    }
}
