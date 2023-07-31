import Foundation
import UIKit

/// Sumarry
///
/// Discussion/Overview
///
/// - Date: 2023-07-27
/// - Version: 1.0.0
public struct Device {
    
    public let devicePlatform: String
    public let deviceOperatingSystem: String
    public let deviceOperatingSystemVersion: String
    public let deviceScreenSize: CGSize
    public let deviceNativeScreenSize: CGSize
    public let deviceDarwinVersion: String?
    
    public static func getDeviceInfo() -> Device {
        return Device(devicePlatform: getDevicePlatform(),
                      deviceOperatingSystem: getDeviceOperatingSystem(),
                      deviceOperatingSystemVersion: getDeviceOperatingSystemVersion(),
                      deviceScreenSize: getDeviceScreenSize(),
                      deviceNativeScreenSize: getDeviceNativeScreenSize(),
                      deviceDarwinVersion: getDeviceDarwinVersion())
    }
}

extension Device {
    
    private static func getDevicePlatform() -> String {
        #if targetEnvironment(simulator)
            return ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "x86_64"
        #else
            var size = 0
            sysctlbyname("hw.machine", nil, &size, nil, 0)
            var machine = [CChar](repeating: 0,  count: Int(size))
            sysctlbyname("hw.machine", &machine, &size, nil, 0)
            return String(cString: machine)
        #endif
    }
    
    private static func getDeviceOperatingSystem() -> String {
        return "iOS"
    }
    
    private static func getDeviceOperatingSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    private static func getDeviceScreenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    private static func getDeviceNativeScreenSize() -> CGSize {
        return UIScreen.main.nativeBounds.size
    }
    
    private static func getDeviceDarwinVersion() -> String? {
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.release, count: Int(_SYS_NAMELEN)), encoding: .ascii)?.trimmingCharacters(in: .controlCharacters)
    }
}
