import Foundation

/// Sumarry
///
/// Discussion/Overview
///
/// - Date: 2023-07-28
/// - Version: 1.0.0
public protocol Serializer {
    
    func queryItems(for event: Event) -> [String: String]
    func toJsonData(for events: [Event]) throws -> Data
}
