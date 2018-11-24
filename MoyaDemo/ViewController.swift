//
//  ViewController.swift
//  MoyaDemo
//
//  Created by DancewithPeng on 2018/11/24.
//  Copyright © 2018 DancewithPeng. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provider = MoyaProvider<MyService>()
        provider.request(.zen) { result in
            switch result {
            case let .success(response):
                
                do {
                    try response.filterSuccessfulStatusCodes()
                    let data = try response.mapJSON()
                }
                catch {
                    
                }
                print("Status Code: \(response.statusCode)")
                print("Headers: \(response.response?.allHeaderFields ?? [:] )")
                print(String(data: response.data, encoding: .utf8) ?? "Nothing!!!")
            case let .failure(error):
                print(error)
            }
        }
    }
    
}

