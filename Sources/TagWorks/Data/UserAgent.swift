//
//  UserAgent.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//

import Foundation

public struct UserAgent {
    
    let application: Application
    let device: Device
    var userAgentString: String {
        [
            "Darwin/\(device.deviceDarwinVersion ?? "Unknown-Version") (\(device.devicePlatform); \(device.deviceOperatingSystem) \(device.deviceOperatingSystemVersion))",
            "\(application.bundleName ?? "Unknown-App")/\(application.bundleShortVersion ?? "Unknown-Version")"
        ].joined(separator: " ")
    }
}
