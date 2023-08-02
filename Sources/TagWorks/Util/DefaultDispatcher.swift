//
//  DefaultDispatcher.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//

import Foundation

public final class DefaultDispatcher: Dispatcher {
    
    private let serializer: Serializer
    private let timeOut: TimeInterval
    private let session: URLSession
    public let baseUrl: URL
    
    public private(set) var userAgent: String?
    
    public init(serializer: Serializer, timeOut: TimeInterval = 5.0, baseUrl: URL, userAgent: String? = nil) {
        self.serializer = serializer
        self.timeOut = timeOut
        self.session = URLSession.shared
        self.baseUrl = baseUrl
        self.userAgent = userAgent ?? UserAgent(application: Application.getApplicationInfo(), device: Device.getDeviceInfo()).userAgentString
    }
    
    private func buildRequest(baseURL: URL, method: String, contentType: String? = nil, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: baseURL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeOut)
        request.httpMethod = method
        body.map { request.httpBody = $0 }
        contentType.map { request.setValue($0, forHTTPHeaderField: "Content-Type") }
        userAgent.map { request.setValue($0, forHTTPHeaderField: "User-Agent") }
        return request
    }
    
    public func send(events: [Event], success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let jsonBody: Data
        do {
            jsonBody = try serializer.toJsonData(for: events)
        } catch  {
            failure(error)
            return
        }
        let request = buildRequest(baseURL: baseUrl, method: "POST", contentType: "application/json; charset=utf-8", body: jsonBody)
        send(request: request, success: success, failure: failure)
    }
    
    private func send(request: URLRequest, success: @escaping ()->(), failure: @escaping (_ error: Error)->()) {
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
        task.resume()
    }
}
