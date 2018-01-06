//
//  BaseServices.swift
//
//  Copyright © 2017 godstar124. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

typealias Success = () -> ()
typealias Failure = (ErrorModel) -> ()

class BaseService {
    static let baseURL = "https://api.gotinder.com/"
    static var token: String?
    
    static func mapError(_ errorData: Data?, error: Error) -> ErrorModel {
        let errorString = error.localizedDescription
        if let data = errorData {
            if let error = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                if let errorJSON = error?["error"] {
                    guard let mappedError = Mapper<ErrorModel>().map(JSONObject: errorJSON) else {
                        return ErrorModel(title: "Error!", message: errorString)
                    }
                    return mappedError
                }
            }
        }
        return ErrorModel(title: "Error!", message: errorString)
    }
}
