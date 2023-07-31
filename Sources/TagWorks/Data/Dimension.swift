import Foundation

/// Sumarry
///
/// Discussion/Overview
///
/// - Date: 2023-07-27
/// - Version: 1.0.0
public struct Dimension: Codable {
    
    let index: Int
    let value: String
    
    public init(index: Int, value: String){
        self.index = index
        self.value = value
    }
}
