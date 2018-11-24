//
//  MyService.swift
//  MoyaDemo
//
//  Created by DancewithPeng on 2018/11/24.
//  Copyright © 2018 DancewithPeng. All rights reserved.
//

import Foundation
import Moya

enum MyService {
    case zen
    case showUser(id: Int)
    case createUser(firstName: String, lastName: String)
    case updateUser(id: Int, firstName: String, lastName: String)
    case showAccounts
}

extension MyService: TargetType {

    var baseURL: URL {
        return URL(string: "https://www.baidu.com:1234/")!
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        return ""
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return .get
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return "Demo".data(using: .utf8)!
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        return .requestParameters(parameters: ["abc": "123"], encoding: URLEncoding.queryString)
    }
    
    /// The headers to be used in the request.
    var headers: [String: String]? {
        return nil
    }
}
