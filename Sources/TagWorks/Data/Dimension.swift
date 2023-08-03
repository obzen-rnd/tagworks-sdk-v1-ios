//
//  Dimension.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//
import Foundation


/// 사용자 정의 디멘전 저장을 위한 클래스입니다.
public final class Dimension: NSObject, Codable {
    
    /// 사용자 정의 디멘전의 index
    let index: Int
    
    /// 사용자 정의 디멘전의 value
    let value: String
    
    
    /// 사용자 정의 디멘전의 기본 생성자입니다.
    /// - Parameters:
    ///   - index: 사용자 정의 디멘전의 index
    ///   - value: 사용자 정의 디멘전의 value
    @objc public init(index: Int, value: String){
        self.index = index
        self.value = value
    }
}
