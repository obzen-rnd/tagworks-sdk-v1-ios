//
//  Event.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//

import Foundation
import CoreGraphics

public struct Event: Codable {
    
    public let uuid: UUID
    let siteId: String
    let visitorId: String
    let userId: String?
    let url: URL?
    let urlReferer: URL?
    let language: String
    var screenResolution: CGSize = Device.getDeviceInfo().deviceScreenSize
    let clientDateTime: Date
    let eventType: String?
    let pageTitle: String?
    let searchKeyword: String?
    let customUserPath: String?
    let dimensions: [Dimension]
}

extension Event {
    public init(tagWorks: TagWorks,
                action: [String] = [],
                url: URL? = nil,
                urlReferer: URL? = nil,
                eventType: String,
                pageTitle: String? = nil,
                searchKeyword: String? = nil,
                customUserPath: String? = nil,
                dimensions: [Dimension] = []) {
        self.uuid = UUID()
        self.siteId = tagWorks.siteId
        self.visitorId = tagWorks.visitorId
        self.userId = tagWorks.userId
        self.url = url ?? tagWorks.currentContentUrlPath
        self.urlReferer = urlReferer
        self.language = Locale.httpAcceptLanguage
        self.clientDateTime = Date()
        self.eventType = eventType
        self.pageTitle = pageTitle
        self.searchKeyword = searchKeyword
        self.customUserPath = customUserPath
        self.dimensions = tagWorks.dimensions + dimensions
    }
}
