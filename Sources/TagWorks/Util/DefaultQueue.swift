//
//  DefaultQueue.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//

import Foundation

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
