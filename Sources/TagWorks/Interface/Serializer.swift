//
//  Serializer.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//

import Foundation

public protocol Serializer {
    
    func queryItems(for event: Event) -> [String: String]
    func toJsonData(for events: [Event]) throws -> Data
}
