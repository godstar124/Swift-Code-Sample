//
//  UserService.swift
//
//  Copyright © 2017 godstar124. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

enum UserAPI: URLRequestConvertible {
    
    case loginUser(request: Mappable)
    case matchUser(matchType: String, userID: String)
    
    var method: HTTPMethod {
        switch self {
        case  .loginUser, .matchUser:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .loginUser:
            return "auth"
        case let .matchUser(matchType, userID):
            return "\(matchType)/\(userID)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try BaseService.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        switch self {
        case let .loginUser(request):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: request.toJSON())
        case .matchUser:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: nil)
        }
        
        if let token = UserService.token {
            urlRequest.setValue(token, forHTTPHeaderField: "x-auth-token")
        }
        return urlRequest
    }
}

class UserService: BaseService {
    static func loginUser(requestModel: Mappable, success: @escaping Success, failure: @escaping Failure) {
        Alamofire.request(UserAPI.loginUser(request: requestModel)).validate().responseObject { (response: DataResponse<LoginResponse>) in
            switch response.result {
            case let .success(value):
                UserService.token = value.token
                success()
            case let .failure(error):
                failure(mapError(response.data, error: error))
            }
        }
    }
    
    static func matchUser(matchType: String, userID: String, failure: @escaping Failure) {
        Alamofire.request(UserAPI.matchUser(matchType: matchType, userID: userID)).responseObject { (response: DataResponse<MatchResponse>) in
            switch response.result {
            case let .failure(error):
                failure(mapError(response.data, error: error))
            default:
                break
            }
        }
    }
}
