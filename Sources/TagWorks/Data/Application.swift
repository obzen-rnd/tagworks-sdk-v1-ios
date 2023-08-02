//
//  Application.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//

import Foundation

public struct Application {
    
    public let bundleDisplayName: String?
    public let bundleName: String?
    public let bundleIdentifier: String?
    public let bundleVersion: String?
    public let bundleShortVersion: String?
    
    public static func getApplicationInfo() -> Application {
        return Application(bundleDisplayName: getBundleDisplayName(),
                           bundleName: getBundleName(),
                           bundleIdentifier: getBundleIdentifier(),
                           bundleVersion: getBundleVersion(),
                           bundleShortVersion: getBundleShortVersion())
    }
}

extension Application {
    
    private static func getBundleDisplayName() -> String? {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }
    
    private static func getBundleName() -> String? {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String
    }
    
    private static func getBundleIdentifier() -> String? {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }
    
    private static func getBundleVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    private static func getBundleShortVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
