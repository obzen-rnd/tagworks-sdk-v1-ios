//
//  TagWorks.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//
import Foundation

/// TagWorks 클래스는 SDK 모듈내에서 가장 최상위에 존재하는 클래스입니다.
final public class TagWorks: NSObject {
    
    // MARK: - 클래스 변수
    
    /// Logger 객체입니다.
    @objc public var logger: Logger = DefaultLogger(minLevel: .warning)
    
    /// TagWorks 인스턴스 객체입니다.
    internal static var _instance: TagWorks?
    
    /// UserDefault 객체입니다.
    internal var tagWorksBase: TagWorksBase
    
    /// 수집된 로그를 발송전 보관하는 컬렉션입니다.
    private var queue: Queue
    
    /// 수집된 로그를 발송하는 객체입니다.
    private let dispatcher: Dispatcher
    
    /// 수집대상이 되는 컨테이너 식별자를 지정합니다.
    /// - Requires: TagManager 에서 발급된 컨테이너 ID를 입력합니다.
    /// - Important: siteId는 "[0-9],[0-9a-zA-Z]" 와 같은 형식을 가집니다.
    internal let siteId: String
    
    /// 수집되는 사용자의 방문자 식별자입니다.
    @objc public var visitorId: String {
        get {
            return currentVisitorId()
        }
        set {
            tagWorksBase.visitorId = newValue
        }
    }
    
    /// 현재 유효한 사용자의 방문자 식별자를 반환합니다.
    /// * 최초로 수집되어 방문자 식별자가 없는 경우 신규 ID를 발급합니다.
    /// * 생성된 방문자 식별자는 UUID를 기반으로 하며 소문자로 발급됩니다.
    /// - Returns: 방문자 식별자
    private func currentVisitorId() -> String {
        let id: String
        if let existingId = tagWorksBase.visitorId {
            id = existingId
        } else {
            id = UUID().uuidString.lowercased()
            tagWorksBase.visitorId = id
        }
        return id
    }
    
    /// 수집되는 사용자의 유저 식별자 (고객 식별자)입니다.
    @objc public var userId: String? {
        get {
            return tagWorksBase.userId
        }
        set {
            tagWorksBase.userId = newValue
        }
    }
    
    /// 수집 허용 여부 입니다.
    @objc public var isOptedOut: Bool {
        get {
            return tagWorksBase.optOut
        }
        set {
            tagWorksBase.optOut = newValue
        }
    }
    
    /// 이벤트 로그의 발송 주기 입니다. (단위 : 초)
    /// * 발송 주기의 기본값은 10 입니다.
    /// * 값을 0으로 지정하는 경우 이벤트 수집 즉시 발송됩니다.
    /// * 값을 0이하로 지정하는 경우 이벤트 로그 발송을 자동으로 수행하지 않습니다.
    ///     - dispatch() 함수를 이용하여 수동으로 발송해야 합니다.
    @objc public var dispatchInterval: TimeInterval = 10.0 {
        didSet {
            startDispatchTimer()
        }
    }
    private var dispatchTimer: Timer?
    
    /// 공통으로 저장되는 디멘전 컬렉션입니다.
    /// * 해당 컬렉션에 저장된 디멘전은 모든 이벤트 호출시 자동으로 들어갑니다.
    /// * 이벤트 호출시 디멘전을 별도로 추가 한 경우 우선적으로 나중에 호출된 디멘전이 저장됩니다.
    internal var dimensions: [Dimension] = []
    
    /// 수집되는 어플리케이션의 기본 Url 주소입니다.
    /// * 수집대상이 되는 어플리케이션의 bundleIdentifier 주소를 기본으로 하며, 별도 지정시 지정된 값으로 수집됩니다.
    @objc public var contentUrl: URL?
    
    /// 수집되는 어플리케이션의 현재 Url 주소입니다.
    /// * PageView 이벤트 호출시 contentUrl + 지정된 Url 경로 순으로 수집됩니다.
    @objc public var currentContentUrlPath: URL?
    
    /// 한번에 발송할 수 있는 이벤트 구조체의 수입니다.
    private let numberOfEventsDispatchedAtOnce = 20
    
    /// 현재 이벤트 로그 발송중 여부입니다.
    private(set) var isDispatching = false
    
    // MARK: - 클래스 함수
    
    /// TagWorks 클래스의 기본 생성자 입니다.
    /// - Parameters:
    ///   - siteId: 수집 대상이 되는 컨테이너 식별자
    ///   - queue: 수집 로그 발송 대기 보관 컬렉션
    ///   - dispatcher: 수집 로그 발송 객체
    required public init(siteId: String, queue: Queue, dispatcher: Dispatcher) {
        self.siteId = siteId
        self.queue = queue
        self.dispatcher = dispatcher
        self.contentUrl = URL(string: "http://\(Application.getApplicationInfo().bundleIdentifier ?? "")")
        self.tagWorksBase = TagWorksBase(suitName: "\(siteId)\(dispatcher.baseUrl.absoluteString)")
        super.init()
        startDispatchTimer()
    }
    
    /// Objective-C 환경에서 호출되는 TagWorks 클래스의 기본 생성자 입니다.
    /// - Parameters:
    ///   - siteId: 수집 대상이 되는 컨테이너 식별자
    ///   - baseUrl: 수집 로그 발송 대기 보관 컬렉션
    ///   - userAgent: 수집 대상의 userAgent 객체
    @objc convenience public init(siteId: String, baseUrl: URL, userAgent: String? = nil) {
        let queue = DefaultQueue()
        let serializer = EventSerializer()
        let dispatcher = DefaultDispatcher(serializer: serializer, baseUrl: baseUrl, userAgent: userAgent)
        self.init(siteId: siteId, queue: queue, dispatcher: dispatcher)
    }
    
    /// 수집 이벤트 호출시 생성된 이벤트 구조체를 Queue에 저장합니다.
    /// - Parameter event: 이벤트 구조체
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
    }
    
    /// 현재 Queue에 저장되어 있는 이벤트 구조체를 강제로 발송합니다.
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
    
    /// 현재 Queue에 저장되어 있는 이벤트 로그를 발송합니다.
    private func dispatchBatch() {
        guard Thread.isMainThread else {
            DispatchQueue.main.sync {
                self.dispatchBatch()
            }
            return
        }
        queue.first(limit: numberOfEventsDispatchedAtOnce) { [weak self] events in
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
                    self.queue.remove(events: events, completion: {
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
    
    /// 이벤트 로그 발생 주기 타이머를 시작합니다.
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

// MARK: - 공용 디멘전

extension TagWorks {
    
    /// 수집 로그의 공용 디멘전을 지정합니다.
    /// * 이미 동일한 인덱스에 지정된 디멘전이 있는 경우 삭제하고 저장됩니다.
    /// - Parameter dimension: 추가할 디멘전 객체
    @objc public func setDimension(dimension: Dimension){
        removeDimension(index: dimension.index)
        dimensions.append(dimension)
    }
    
    /// 수집 로그의 공용 디멘전을 지정합니다.
    /// * 이미 동일한 인덱스에 지정된 디멘전이 있는 경우 삭제하고 저장됩니다.
    /// - Parameters:
    ///   - index: 추가할 디멘전 index
    ///   - value: 추가할 디멘전 value
    @objc public func setDimension(index: Int, value: String){
        setDimension(dimension: Dimension(index: index, value: value))
    }
    
    /// 수집 로그의 공용 디멘전을 제거합니다.
    /// - Parameter index: 삭제할 디멘전 index
    @objc public func removeDimension(index: Int){
        dimensions = dimensions.filter({
            dimension in dimension.index != index
        })
    }
}

// MARK: - 수집 이벤트

extension TagWorks {
    
    /// 사용자 지정 이벤트를 수집합니다.
    /// - Parameter event: 사용자 지정 이벤트 객체
    public func event(_ event: Event){
        queue(event: event)
    }
    
    /// 이벤트를 수집합니다.
    /// - Parameters:
    ///   - eventType: 이벤트 발생 유형
    ///   - dimensions: 사용자 정의 디멘전
    ///   - customUserPath: 사용자 정의 경로
    public func event(eventType: String, dimensions: [Dimension] = [], customUserPath: String? = nil){
        let event = Event(tagWorks: self, eventType: eventType, customUserPath: customUserPath, dimensions: dimensions)
        queue(event: event)
    }
    
    /// 이벤트를 수집합니다.
    /// - Parameters:
    ///   - eventType: 이벤트 발생 유형
    ///   - dimensions: 사용자 정의 디멘전
    ///   - customUserPath: 사용자 정의 경로
    @objc public func event(eventType: Tag, dimensions: [Dimension] = [], customUserPath: String? = nil){
        event(eventType: eventType.event, dimensions: dimensions, customUserPath: customUserPath)
    }
    
    
    /// 현재 사용자의 페이지를 수집합니다.
    /// - Parameters:
    ///   - pagePath: 현재 페이지 경로
    ///   - pageTitle: 현재 페이지 제목
    ///   - dimensions: 사용자 정의 디멘전
    ///   - customUserPath: 사용자 정의 경로
    @objc public func pageView(pagePath: [String], pageTitle: String?, dimensions: [Dimension] = [], customUserPath: String? = nil){
        currentContentUrlPath = self.contentUrl?.appendingPathComponent(pagePath.joined(separator: "/"))
        let event = Event(tagWorks: self, eventType: Tag.pageView.event, pageTitle: pageTitle, customUserPath: customUserPath, dimensions: dimensions)
        queue(event: event)
    }
    
    /// 검색 키워드를 수집합니다.
    /// - Parameters:
    ///   - keyword: 검색 키워드
    ///   - dimensions: 사용자 정의 디멘전
    ///   - customUserPath: 사용자 정의 경로
    @objc public func searchKeyword(keyword: String, dimensions: [Dimension] = [], customUserPath: String? = nil){
        let event = Event(tagWorks: self, eventType: Tag.search.event, searchKeyword: keyword, customUserPath: customUserPath, dimensions: dimensions)
        queue(event: event)
    }
}
