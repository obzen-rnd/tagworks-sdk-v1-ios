//
//  Logger.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//

import Foundation

@objc public protocol Logger {
    func log(_ message: @autoclosure () -> String, with level: LogLevel, file: String, function: String, line: Int)
}
