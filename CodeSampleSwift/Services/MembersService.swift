//
//  MembersService.swift
//  CodeSampleSwift
//
//  Copyright © 2017 godstar124. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

enum MembersAPI: URLRequestConvertible {
    case recommendedUsers
    
    var method: HTTPMethod {
        switch self {
        case  .recommendedUsers:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .recommendedUsers:
            return "user/recs"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try BaseService.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        switch self {
        case .recommendedUsers:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: nil)
            urlRequest.setValue("Tinder/4.7.1 (iPhone; iOS 9.2; Scale/2.00)", forHTTPHeaderField: "User-Agent")
        }
        if let token = UserService.token {
            urlRequest.setValue(token, forHTTPHeaderField: "x-auth-token")
        }
        return urlRequest
    }
}

class MembersService: BaseService {
    static func recommendedUsers(success: @escaping ([User]) -> (), failure: @escaping Failure) {
        Alamofire.request(MembersAPI.recommendedUsers).validate().responseObject { (response: DataResponse<UsersResponse>) in
            switch response.result {
            case let .success(value):
                success(value.users)
            case let .failure(error):
                failure(mapError(response.data, error: error))
            }
        }
    }
}
