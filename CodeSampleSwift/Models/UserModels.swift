//
//  UserModels.swift
//
//  Copyright © 2017 godstar124. All rights reserved.
//

import Foundation
import ObjectMapper

enum UserMatch: String {
    case pass = "pass"
    case like = "like"
}

struct User: Mappable {
    var name: String?
    var userID: String?
    var bio: String?
    var gender: Bool = false
    var photos = [UserPhoto]()
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.name <- map["name"]
        self.userID <- map["_id"]
        self.bio <- map["bio"]
        self.gender <- map["gender"]
        self.photos <- map["photos"]
    }
}

struct UserPhoto: Mappable {
    var photoID: String?
    var url: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.photoID <- map["id"]
        self.url <- map["url"]
    }
}
