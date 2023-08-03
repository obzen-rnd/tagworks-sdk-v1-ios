//
//  Logger.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//
import Foundation

/// Logger 클래스의 인터페이스입니다.
@objc public protocol Logger {
    func log(_ message: @autoclosure () -> String, with level: LogLevel, file: String, function: String, line: Int)
}
