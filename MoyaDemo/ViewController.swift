//
//  ViewController.swift
//  MoyaDemo
//
//  Created by DancewithPeng on 2018/11/24.
//  Copyright © 2018 DancewithPeng. All rights reserved.
//

import UIKit
import Moya
import Result


class Demo {
    static let shared = Demo()
    var count: Int = 0
}

class MyPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        print("\(#function)")
        return request
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        print("\(#function)")
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print("\(#function)")
    }
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        print("\(#function)")
        return result
    }
}


class ViewController: UIViewController {
    
    var provider2: MoyaProvider<MyService>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provider = MoyaProvider<MyService>()
        provider.request(.zen) { result in
            switch result {
            case let .success(response):
                
                do {
                    let successResponse = try response.filterSuccessfulStatusCodes()
                    let data = try successResponse.mapJSON()
                    print("数据正确")
                    print("\(data)")
                }
                catch MoyaError.jsonMapping(response) {
                    print("解析错误")
                    print(response)
                }
                catch {
                    print("请求错误")
                    print(error)
                }
            case let .failure(error):
                print("网络错误")
                print(error)
            }
        }
        
        // endpointClosure 可以从target到endpoint做一层处理
        // requestClosure 可以从endpoint到requet做一层处理
        // plugins可以在网络发送之前或者结束只有做一层处理
        provider2 = MoyaProvider<MyService>(endpointClosure: { (service) -> Endpoint in
            let ep = MoyaProvider.defaultEndpointMapping(for: service)
            print("endpointClosure... \(Demo.shared.count)")
            return ep
        }, requestClosure: { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
            do {
                let request = try endpoint.urlRequest()
                print("requestClosure... \(request) \(Demo.shared.count)")
                done(.success(request))
            }
            catch {
                done(.failure(MoyaError.underlying(error, nil)))
            }
        }, plugins: [NetworkLoggerPlugin(), MyPlugin()])
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        Demo.shared.count += 1                
        
        provider2?.request(.zen, completion: { (result) in
            switch result {
            case let .success(response):
                
                do {
                    let successResponse = try response.filterSuccessfulStatusCodes()
                    let data = try successResponse.mapJSON()
                    print("数据正确")
                    print("\(data)")
                }
                catch MoyaError.jsonMapping(response) {
                    print("解析错误")
                    print(response)
                }
                catch {
                    print("请求错误")
                    print(error)
                }
            case let .failure(error):
                print("网络错误")
                print(error)
            }
        })
    }
    
}

