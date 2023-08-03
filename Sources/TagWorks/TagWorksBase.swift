//
//  TagWorksBase.swift
//  TagWorks SDK for iOS
//
//  Copyright (c) 2023 obzen All rights reserved.
//
import Foundation

/// TagWorks에서 사용하는 UserDefault 관리 클래스입니다.
internal struct TagWorksBase {
    
    /// UserDefault 객체입니다.
    private let userDefaults: UserDefaults
    
    /// UserDefault 인스턴스 초기화시 지정하는 식별자입니다.
    /// - Parameter suitName: UserDefault 식별자
    init(suitName: String?){
        self.userDefaults = UserDefaults(suiteName: suitName)!
    }
    
    /// 유저 식별자 (고객 식별자)를 저장 및 반환합니다.
    public var userId: String? {
        get {
            return userDefaults.string(forKey: UserDefaultKey.userId)
        }
        set {
            userDefaults.setValue(newValue, forKey: UserDefaultKey.userId)
            userDefaults.synchronize()
        }
    }
    
    /// 방문자 식별자를 저장 및 반환합니다.
    public var visitorId: String? {
        get {
            return userDefaults.string(forKey: UserDefaultKey.visitorId)
        }
        set {
            userDefaults.setValue(newValue, forKey: UserDefaultKey.visitorId)
            userDefaults.synchronize()
        }
    }
    
    /// 수집 허용 여부를 저장 및 반환합니다.
    public var optOut: Bool {
        get {
            return userDefaults.bool(forKey: UserDefaultKey.optOut)
        }
        set {
            userDefaults.setValue(newValue, forKey: UserDefaultKey.optOut)
            userDefaults.synchronize()
        }
    }
}
