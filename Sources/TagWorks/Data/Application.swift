//
//  Application.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//
import Foundation

/// 수집되는 어플리케이션의 식별 정보를 저장하는 구조체입니다.
public struct Application {
    
    /// 어플리케이션 표기명
    public let bundleDisplayName: String?
    
    /// 어플리케이션 고유명
    public let bundleName: String?
    
    /// 어플리케이션 Identifier
    public let bundleIdentifier: String?
    
    /// 어플리케이션 Version
    public let bundleVersion: String?
    
    /// 어플리케이션 ShortVersion
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
    
    
    /// 어플리케이션 표기명을 반환합니다.
    /// - Returns: 어플리케이션 표기명
    private static func getBundleDisplayName() -> String? {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }
    
    /// 어플리케이션 고유명을 반환합니다.
    /// - Returns: 어플리케이션 고유명
    private static func getBundleName() -> String? {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String
    }
    
    /// 어플리케이션 Identifier를 반환합니다.
    /// - Returns: 어플리케이션 Identifier
    private static func getBundleIdentifier() -> String? {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }
    
    /// 어플리케이션 Version을 반환합니다.
    /// - Returns: 어플리케이션 Version
    private static func getBundleVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    /// 어플리케이션 ShortVersion을 반환합니다.
    /// - Returns: 어플리케이션 ShortVersion
    private static func getBundleShortVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
