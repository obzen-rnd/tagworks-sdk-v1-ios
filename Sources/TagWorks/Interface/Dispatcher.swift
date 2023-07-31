import Foundation

/// Sumarry
///
/// Discussion/Overview
///
/// - Date: 2023-07-28
/// - Version: 1.0.0
public protocol Dispatcher {
    
    var baseUrl: URL { get }
    var userAgent: String? { get }
    func send(events: [Event], success: @escaping ()->(), failure: @escaping (_ error: Error)->())
}
