import Foundation

/// Sumarry
///
/// Discussion/Overview
///
/// - Date: 2023-07-27
/// - Version: 1.0.0
public protocol Queue {
    
    var size: Int { get }
    mutating func enqueue(events: [Event], completion: (()-> Void)?)
    mutating func dequeue(events: [Event], completion: @escaping ()->Void)
    func peek(limit: Int, completion: @escaping (_ items: [Event])->Void)
}

extension Queue {
    
    mutating func enqueue(event: Event, completion: (()->Void)? = nil) {
        enqueue(events: [event], completion: completion)
    }
}

