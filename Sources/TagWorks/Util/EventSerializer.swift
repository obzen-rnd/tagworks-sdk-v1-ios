import Foundation

/// Sumarry
///
/// Discussion/Overview
///
/// - Date: 2023-07-28
/// - Version: 1.0.0
final class EventSerializer: Serializer {
    
    internal func queryItems(for event: Event) -> [String : String] {
        event.queryItems.reduce(into: [String:String]()) {
            $0[$1.name] = $1.value
        }.compactMapValues {
            $0.addingPercentEncoding(withAllowedCharacters: .urlQueryParameterAllowed)
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
        return ""
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
