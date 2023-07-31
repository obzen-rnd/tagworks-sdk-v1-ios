import Foundation

/// Sumarry
///
/// Discussion/Overview
///
/// - Date: 2023-07-28
/// - Version: 1.0.0
public final class DefaultQueue: NSObject, Queue {
    
    private var items = [Event]()
    
    public var size: Int {
        return items.count
    }
    
    public func enqueue(events: [Event], completion: (() -> Void)?) {
        items.append(contentsOf: events)
        completion?()
    }
    
    public func dequeue(events: [Event], completion: @escaping () -> Void) {
        items = items.filter( {event in !events.contains(where: { target in target.uuid == event.uuid })})
    }
    
    public func peek(limit: Int, completion: @escaping ([Event]) -> Void) {
        let amount = [limit, size].min()!
        let dequeueItems = Array(items[0..<amount])
        completion(dequeueItems)
    }
}
