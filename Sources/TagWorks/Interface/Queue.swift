//
//  Queue.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//

import Foundation

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

