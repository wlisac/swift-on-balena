//
//  DockerHost.swift
//  SwiftOnBalena
//
//  Created by Will Lisac on 5/11/19.
//

import Foundation

enum DockerHost {
    static func host(for architecture: Architecture) -> String {
        switch architecture {
        case .aarch64:
            return "6e4f550.local"
        case .armv7hf:
            return "4184b8e.local"
        case .rpi:
            return "0dc92cf.local"
        }
    }
}
