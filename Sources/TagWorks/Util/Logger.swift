import Foundation

/// Sumarry
///
/// Discussion/Overview
///
/// - Date: 2023-07-28
/// - Version: 1.0.0
@objc public enum LogLevel: Int {
    case verbose = 10
    case debug = 20
    case info = 30
    case warning = 40
    case error = 50
    
    var shortcut: String {
        switch self {
        case .error: return "E"
        case .warning: return "W"
        case .info: return "I"
        case .debug: return "D"
        case .verbose: return "V"
        }
    }
}

@objc public protocol Logger {
    func log(_ message: @autoclosure () -> String, with level: LogLevel, file: String, function: String, line: Int)
}

extension Logger {
    func verbose(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message(), with: .verbose, file: file, function: function, line: line)
    }
    func debug(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message(), with: .debug, file: file, function: function, line: line)
    }
    func info(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message(), with: .info, file: file, function: function, line: line)
    }
    func warning(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message(), with: .warning, file: file, function: function, line: line)
    }
    func error(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message(), with: .error, file: file, function: function, line: line)
    }
}

public final class DisabledLogger: Logger {
    public func log(_ message: @autoclosure () -> String, with level: LogLevel, file: String = #file, function: String = #function, line: Int = #line) { }
}

@objc public final class DefaultLogger: NSObject, Logger {
    private let dispatchQueue = DispatchQueue(label: "DefaultLogger", qos: .background)
    private let minLevel: LogLevel
    
    @objc public init(minLevel: LogLevel) {
        self.minLevel = minLevel
        super.init()
    }
    
    public func log(_ message: @autoclosure () -> String, with level: LogLevel, file: String = #file, function: String = #function, line: Int = #line) {
        guard level.rawValue >= minLevel.rawValue else { return }
        let messageToPrint = message()
        dispatchQueue.async {
            print("TagWorks [\(level.shortcut)] \(messageToPrint)")
        }
    }
}
