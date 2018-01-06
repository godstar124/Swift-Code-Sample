//
//  UserServiceResponses.swift
//
//  Copyright © 2017 godstar124. All rights reserved.
//
import Foundation
import ObjectMapper

struct MatchResponse: Mappable {
    var match: Bool = false
    var likesRemaining: Int = 0
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.match <- map["match"]
        self.likesRemaining <- map["likes_remaining"]
    }
}

struct LoginResponse: Mappable {
    var token: String!
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.token <- map["token"]
    }
}
