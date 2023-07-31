import Foundation

/// Sumarry
///
/// Discussion/Overview
///
/// - Date: 2023-07-27
/// - Version: 1.0.0
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
