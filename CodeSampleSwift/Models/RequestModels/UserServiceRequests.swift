//
//  UserServiceRequests.swift
//
//  Copyright © 2017 godstar124. All rights reserved.
//

import Foundation
import ObjectMapper

struct LoginRequest: Mappable {
    var facebookID: String?
    var facebookToken: String?
    
    init?(map: Map) {
    }
    
    init(facebookID: String?, facebookToken: String?) {
        self.facebookID = facebookID
        self.facebookToken = facebookToken
    }
    
    mutating func mapping(map: Map) {
        self.facebookID <- map["facebook_id"]
        self.facebookToken <- map["facebook_token"]
    }
}
