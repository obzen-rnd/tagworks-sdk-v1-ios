//
//  EventSerializer.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//

import Foundation

final class EventSerializer: Serializer {
    
    internal func queryItems(for event: Event) -> [String : String] {
        event.queryItems.reduce(into: [String:String]()) {
            $0[$1.name] = $1.value
        }
    }
    
    internal func toJsonData(for events: [Event]) throws -> Data {
        let eventsAsQueryItems: [[String: String]] = events.map { self.queryItems(for: $0) }
        let serializedEvents = eventsAsQueryItems.map { items in
            items.map {
                "\($0.key)=\($0.value)"
            }.joined(separator: "&")
        }
        let body = ["requests": serializedEvents.map({ "?\($0)" })]
        return try JSONSerialization.data(withJSONObject: body, options: [])
    }
}

fileprivate extension Event {
    
    private func serializeEventString() -> String {
        var eventCommonItems: [URLQueryItem] = []
        eventCommonItems.append(URLQueryItem(name: TagWorksParams.EventParams.clientDateTime, value: CommonUtil.Formatter.iso8601DateFormatter.string(from: clientDateTime)))
        eventCommonItems.append(URLQueryItem(name: TagWorksParams.EventParams.triggerType, value: eventType))
        if pageTitle != nil {
            eventCommonItems.append(URLQueryItem(name: TagWorksParams.EventParams.pageTitle, value: pageTitle))
        }
        if searchKeyword != nil {
            eventCommonItems.append(URLQueryItem(name: TagWorksParams.EventParams.searchKeyword, value: searchKeyword))
        }
        if customUserPath != nil {
            eventCommonItems.append(URLQueryItem(name: TagWorksParams.EventParams.customUserPath, value: customUserPath))
        }
        let customDimensionItems = dimensions.map {
            URLQueryItem(name: TagWorksParams.EventParams.customDimension + "\($0.index)", value: $0.value)
        }
        let eventsAsQueryItems = eventCommonItems + customDimensionItems
        let serializedEvents = eventsAsQueryItems.reduce(into: [String:String]()) {
            $0[$1.name] = $1.value
        }
        return serializedEvents.map{
            "\($0.key)=\($0.value)"
        }.joined(separator: "&")
    }
    
    var queryItems: [URLQueryItem] {
        get {
            return [
                URLQueryItem(name: TagWorksParams.URLQueryParams.siteId, value: siteId),
                URLQueryItem(name: TagWorksParams.URLQueryParams.visitorId, value: visitorId),
                URLQueryItem(name: TagWorksParams.URLQueryParams.userId, value: userId),
                URLQueryItem(name: TagWorksParams.URLQueryParams.url, value: url?.absoluteString),
                URLQueryItem(name: TagWorksParams.URLQueryParams.urlReferer, value: urlReferer?.absoluteString),
                URLQueryItem(name: TagWorksParams.URLQueryParams.language, value: language),
                URLQueryItem(name: TagWorksParams.URLQueryParams.clientDateTime, value: CommonUtil.Formatter.iso8601DateFormatter.string(from: clientDateTime)),
                URLQueryItem(name: TagWorksParams.URLQueryParams.screenSize, value: String(format: "%1.0fx%1.0f", screenResolution.width, screenResolution.height)),
                URLQueryItem(name: TagWorksParams.URLQueryParams.event, value: serializeEventString())
            ]
        }
    }
}

fileprivate extension CharacterSet {
    
    static var urlQueryParameterAllowed: CharacterSet {
        return CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: ###"&/?;',+"!^()=@*$"###))
    }
}
