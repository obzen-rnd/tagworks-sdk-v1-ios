//
//  Dispatcher.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//

import Foundation

public protocol Dispatcher {
    
    var baseUrl: URL { get }
    var userAgent: String? { get }
    func send(events: [Event], success: @escaping ()->(), failure: @escaping (_ error: Error)->())
}
