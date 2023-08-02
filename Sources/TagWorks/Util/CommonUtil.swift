//
//  CommonUtil.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//

import Foundation

final class CommonUtil {
    
    internal struct Formatter {
        internal static let iso8601DateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            return formatter
        }()
    }
}

extension Locale {
    
    static var httpAcceptLanguage: String {
        var components: [String] = []
        for (index, languageCode) in preferredLanguages.enumerated() {
            let quality = 1.0 - (Double(index) * 0.1)
            components.append("\(languageCode);q=\(quality)")
            if quality <= 0.5 {
                break
            }
        }
        return components.joined(separator: ",")
    }
}
