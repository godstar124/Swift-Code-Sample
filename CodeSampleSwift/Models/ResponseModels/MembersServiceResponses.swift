//
//  MembersServiceResponses.swift
//  CodeSampleSwift
//
//  Copyright © 2017 godstar124. All rights reserved.
//

import Foundation
import ObjectMapper

struct UsersResponse: Mappable {
    var users = [User]()
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.users <- map["results"]
    }
}
