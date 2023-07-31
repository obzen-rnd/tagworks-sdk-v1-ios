import Foundation

/// Sumarry
///
/// Discussion/Overview
///
/// - Date: 2023-07-27
/// - Version: 1.0.0
internal struct TagWorksParams {
    
    internal struct Key {
        static let userId = "TagWorksUserIdKey"
        static let visitorId = "TagWorksVisitorIdKey"
        static let optOut = "TagWorksOptOutKey"
    }
}

extension TagWorksParams {
    
    internal struct URLQueryParams {
        static let siteId = "idsite"
        static let visitorId = "_id"
        static let userId = "uid"
        static let language = "lang"
        static let url = "url"
        static let urlReferer = "urlref"
        static let event = "e_c"
        static let clientDateTime = "cdt"
        static let screenSize = "res"
    }
    
    internal struct EventParams {
        static let visitorId = "ozvid"
        static let clientDateTime = "obz_client_date"
        static let triggerType = "obz_trg_type"
        static let customUserPath = "obz_user_path"
        static let searchKeyword = "obz_search_keyword"
        static let customDimension = "cstm_d"
        static let pageTitle = "epgtl_nm"
    }
}
