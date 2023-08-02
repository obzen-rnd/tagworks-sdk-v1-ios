//
//  Dimension.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//

import Foundation

public final class Dimension: NSObject, Codable {
    
    let index: Int
    let value: String
    
    @objc public init(index: Int, value: String){
        self.index = index
        self.value = value
    }
}
