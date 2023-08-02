//
//  TagWorks.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//

import Foundation

final public class TagWorks: NSObject {
    
    @objc public var logger: Logger = DefaultLogger(minLevel: .warning)
    internal static var _instance: TagWorks?
    internal var tagWorksBase: TagWorksBase
    
    private var queue: Queue
    private let dispatcher: Dispatcher
    
    internal let siteId: String
    internal var nextEventStartsANewSession = true
    
    @objc public var visitorId: String {
        get {
            return currentVisitorId()
        }
        set {
            tagWorksBase.visitorId = newValue
        }
    }
    
    private func currentVisitorId() -> String {
        let id: String
        if let existingId = tagWorksBase.visitorId {
            id = existingId
        } else {
            id = UUID().uuidString
            tagWorksBase.visitorId = id
        }
        return id
    }
    
    @objc public var userId: String? {
        get {
            return tagWorksBase.userId
        }
        set {
            tagWorksBase.userId = newValue
        }
    }
    
    @objc public var isOptedOut: Bool {
        get {
            return tagWorksBase.optOut
        }
        set {
            tagWorksBase.optOut = newValue
        }
    }
    
    internal var dimensions: [Dimension] = []
    
    @objc public var contentUrl: URL?
    @objc public var currentContentUrlPath: URL?
                
    required public init(siteId: String, queue: Queue, dispatcher: Dispatcher) {
        self.siteId = siteId
        self.queue = queue
        self.dispatcher = dispatcher
        self.contentUrl = URL(string: "http://\(Application.getApplicationInfo().bundleIdentifier ?? "")")
        self.tagWorksBase = TagWorksBase(suitName: "\(siteId)\(dispatcher.baseUrl.absoluteString)")
        super.init()
        startDispatchTimer()
    }
    
    @objc convenience public init(siteId: String, baseUrl: URL, userAgent: String? = nil) {
        let queue = DefaultQueue()
        let serializer = EventSerializer()
        let dispatcher = DefaultDispatcher(serializer: serializer, baseUrl: baseUrl, userAgent: userAgent)
        self.init(siteId: siteId, queue: queue, dispatcher: dispatcher)
    }
    
    internal func queue(event: Event) {
        guard Thread.isMainThread else {
            DispatchQueue.main.sync {
                self.queue(event: event)
            }
            return
        }
        guard !isOptedOut else { return }
        logger.verbose("Queued event: \(event)")
        queue.enqueue(event: event)
        nextEventStartsANewSession = false
    }
    
    private let numberOfEventsDispatchedAtOnce = 20
    private(set) var isDispatching = false
    
    @objc public func dispatch() {
        guard !isDispatching else {
            logger.verbose("is already dispatching.")
            return
        }
        guard queue.size > 0 else {
            logger.info("No need to dispatch. Dispatch queue is empty.")
            startDispatchTimer()
            return
        }
        logger.info("Start dispatching events")
        isDispatching = true
        dispatchBatch()
    }
    
    private func dispatchBatch() {
        guard Thread.isMainThread else {
            DispatchQueue.main.sync {
                self.dispatchBatch()
            }
            return
        }
        queue.peek(limit: numberOfEventsDispatchedAtOnce) { [weak self] events in
            guard let self = self else { return }
            guard events.count > 0 else {
                self.isDispatching = false
                self.startDispatchTimer()
                self.logger.info("Finished dispatching events")
                return
            }
            self.dispatcher.send(events: events, success: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.queue.dequeue(events: events, completion: {
                        self.logger.info("Dispatched batch of \(events.count) events.")
                        DispatchQueue.main.async {
                            self.dispatchBatch()
                        }
                    })
                }
            }, failure: { [weak self] error in
                guard let self = self else { return }
                self.isDispatching = false
                self.startDispatchTimer()
                self.logger.warning("Failed dispatching events with error \(error)")
            })
        }
    }
    
    @objc public var dispatchInterval: TimeInterval = 10.0 {
        didSet {
            startDispatchTimer()
        }
    }
    private var dispatchTimer: Timer?
    
    private func startDispatchTimer() {
        guard Thread.isMainThread else {
            DispatchQueue.main.sync {
                self.startDispatchTimer()
            }
            return
        }
        guard dispatchInterval > 0  else { return }
        if let dispatchTimer = dispatchTimer {
            dispatchTimer.invalidate()
            self.dispatchTimer = nil
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dispatchTimer = Timer.scheduledTimer(timeInterval: self.dispatchInterval, target: self, selector: #selector(self.dispatch), userInfo: nil, repeats: false)
        }
    }
}

extension TagWorks {
    
    public func event(_ event: Event){
        queue(event: event)
    }
    
    public func event(eventType: String, dimensions: [Dimension] = [], customUserPath: String? = nil){
        let event = Event(tagWorks: self, eventType: eventType, customUserPath: customUserPath, dimensions: dimensions)
        queue(event: event)
    }
}

extension TagWorks {
    
    public func pageView(pagePath: [String], pageTitle: String?, dimensions: [Dimension] = [], customUserPath: String? = nil){
        currentContentUrlPath = self.contentUrl?.appendingPathComponent(pagePath.joined(separator: "/"))
        let event = Event(tagWorks: self, eventType: TagTypeParams.PAGE_VIEW, pageTitle: pageTitle, customUserPath: customUserPath, dimensions: dimensions)
        queue(event: event)
    }
}

