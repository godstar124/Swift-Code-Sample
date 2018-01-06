//
//  ErrorModel.swift
//
//  Copyright © 2017 godstar124. All rights reserved.
//

import Foundation
import ObjectMapper

struct ErrorModel: Mappable, AlertMessageProtocol {
    var title: String?
    var message: String?
    
    init?(map: Map) {
    }
    
    init(title:String?, message:String?) {
        self.title = title
        self.message = message
    }
    
    mutating func mapping(map: Map) {
        title <- map["caption"]
        message <- map["description"]
    }
}
