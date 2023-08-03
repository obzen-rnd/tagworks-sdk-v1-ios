//
//  UserAgent.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//
import Foundation

/// 수집 대상의 UserAgent 정보를 저장하는 구조체입니다.
public struct UserAgent {
    
    /// 어플리케이션 정보 저장 구조체
    let application: Application
    
    /// 디바이스 정보 저장 구조체
    let device: Device
    
    /// 수집 대상 UserAgent 정보를 반환합니다.
    var userAgentString: String {
        [
            "Darwin/\(device.deviceDarwinVersion ?? "Unknown-Version") (\(device.devicePlatform); \(device.deviceOperatingSystem) \(device.deviceOperatingSystemVersion))",
            "\(application.bundleName ?? "Unknown-App")/\(application.bundleShortVersion ?? "Unknown-Version")"
        ].joined(separator: " ")
    }
}
