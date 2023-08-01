//
//  Tracker.swift
//  TagWorks_Example
//
//  Created by Digital on 2023/08/01.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import TagWorks

class Tracker  {
    static let shared: TagWorks = {
        let tagWorks = TagWorks(siteId: "61,YbIxGr9e", baseUrl: URL(string: "http://192.168.20.51:81/obzenTagWorks")!)
        tagWorks.logger = DefaultLogger(minLevel: .verbose)
        return tagWorks
    }()
}
