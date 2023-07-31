import Foundation

/// Sumarry
///
/// Discussion/Overview
///
/// - Date: 2023-07-27
/// - Version: 1.0.0
internal struct TagWorksBase {
    
    private let userDefaults: UserDefaults
    
    init(suitName: String?){
        self.userDefaults = UserDefaults(suiteName: suitName)!
    }
    
    public var userId: String? {
        get {
            return userDefaults.string(forKey: TagWorksParams.Key.userId)
        }
        set {
            userDefaults.setValue(newValue, forKey: TagWorksParams.Key.userId)
            userDefaults.synchronize()
        }
    }
    
    public var visitorId: String? {
        get {
            return userDefaults.string(forKey: TagWorksParams.Key.visitorId)
        }
        set {
            userDefaults.setValue(newValue, forKey: TagWorksParams.Key.visitorId)
            userDefaults.synchronize()
        }
    }
    
    public var optOut: Bool {
        get {
            return userDefaults.bool(forKey: TagWorksParams.Key.optOut)
        }
        set {
            userDefaults.setValue(newValue, forKey: TagWorksParams.Key.optOut)
            userDefaults.synchronize()
        }
    }
}
