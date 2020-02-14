//
//  ApiController.swift
//  tomato
//
//  Created by cm0532_macAir on 2019/12/30.
//  Copyright © 2019 cm0532_macAir. All rights reserved.
//

import Foundation

//
//  ApiHelper.swift
//  APIHelperTest
//
//  Created by yilong wu on 2019/5/12.
//  Copyright © 2019 yilong wu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//typealias Myclosure1 = () ->AnyObject;

class NetWorkController: NSObject {
    // 伺服器網址
    static let rootUrl : String = "http://34.85.51.56/api"
    let headersContent:[String:String] = ["Authorization":"Bearer \(token)"]
//    "http://104.199.184.191:8080" 孝瑜
    
    // 單例
    static let sharedInstance = NetWorkController()
    
    var alamofireManager:Alamofire.SessionManager!
    
    fileprivate override init() {
        // 初始化
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 20
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
      func register(api : String, params : Dictionary<String, Any>, callBack:((JSON) -> ())?){
            alamofireManager.request(NetWorkController.rootUrl + api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:])
                .validate(statusCode: 200 ..< 500).responseJSON
                {
                    (response) in
                    if response.result.isSuccess{
                        let jsonData = try! JSON(data: response.data!)
    //                    let status = jsonData.dictionary!["Status Code"]?.int
    //
    //                    if status == 200 {
    //                        callBack?(jsonData)
    //                        print("請求成功 \(String(describing: response.result.value))")
    //                    }else{
    //                        print("請求失敗 callBack 後端寫錯那種: \(response.debugDescription)")
    //                    }
                        
                        print("請求成功 \(String(describing: response.result.value))")
                        callBack?(jsonData)
                        
                    }else{
                        print("請求失敗 callBack onFailure那種: \(response.debugDescription)")
                    }
                }
        }
    let queue = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
    
    func connectApiByAnotherWay(api:String, params : Dictionary<String, Any> , header : Dictionary<String, String> ){
        Alamofire.request(NetWorkController.rootUrl , parameters: params)
            .response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer(), completionHandler: { response in
            // You are now running on the concurrent `queue` you created earlier.
            print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
            if response.result.isSuccess{
                let jsonData = try! JSON(data: response.data!)
                print("請求成功 \(String(describing: response.result.value))")
//               callBack?(jsonData)
           }else{
                print("請求失敗 callBack onFailure那種: \(response.debugDescription)")
                                   }
            // Validate your JSON response and convert into model objects if necessary
//            print(response.result.value)

            // To update anything on the main thread, just jump back on like so.
            DispatchQueue.main.async {
                print("Am I back on the main thread: \(Thread.isMainThread)")
            }
        }
    )}
    
    func connectApiByDelete(api : String, params : Dictionary<String, Any>, header : Dictionary<String, String>, callBack:((JSON) -> ())?){
        alamofireManager.request(NetWorkController.rootUrl + api, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200 ..< 500).responseJSON
            {
                (response) in
                if response.result.isSuccess{
                    let jsonData = try! JSON(data: response.data!)

                    print(jsonData.description)
                    callBack?(jsonData)
                    
                }else{
                    print("請求失敗 callBack onFailure那種: \(response.debugDescription)")
                }
            }
    }
    
    func connectApiByPost(api : String, params : Dictionary<String, Any>, header : Dictionary<String, String>, callBack:((JSON) -> ())?){
        alamofireManager.request(NetWorkController.rootUrl + api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200 ..< 500).responseJSON
            {
                (response) in
                if response.result.isSuccess{
                    let jsonData = try! JSON(data: response.data!)

                    print(jsonData.description)
                    callBack?(jsonData)
                    
                }else{
                    print("請求失敗 callBack onFailure那種: \(response.debugDescription)")
                }
            }
    }
    func connectApiByGet(api : String, header : Dictionary<String, String>, callBack:((JSON) -> ())?){
        alamofireManager.request(NetWorkController.rootUrl + api, method: .get, encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200 ..< 500).responseJSON
            {
                (response) in
                if response.result.isSuccess{
                    let jsonData = try! JSON(data: response.data!)

                    print(jsonData.description)
                    callBack?(jsonData)
                    
                }else{
                    print("請求失敗 callBack onFailure那種: \(response.debugDescription)")
                }
            }
    }
    
       func connectApiByPatch(api : String, params : Dictionary<String, Any>, header : Dictionary<String, String>, callBack:((JSON) -> ())?){
                alamofireManager.request(NetWorkController.rootUrl + api, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: header)
                    .validate(statusCode: 200 ..< 500).responseJSON
                    {
                        (response) in
                        if response.result.isSuccess{
                            let jsonData = try! JSON(data: response.data!)

                            print(jsonData.description)
                            callBack?(jsonData)
                            
                        }else{
                            print("請求失敗 callBack onFailure那種: \(response.debugDescription)")
                        }
                    }
            }
    
    func get(api : String, callBack:((JSON) -> ())?){
            alamofireManager.request(NetWorkController.rootUrl + api, encoding: JSONEncoding.default, headers: [:])
                .validate(statusCode: 200 ..< 500).responseJSON
                {
                    (response) in
                    if response.result.isSuccess{
                        let jsonData = try! JSON(data: response.data!)
    //                    let status = jsonData.dictionary!["Status Code"]?.int
    //
    //                    if status == 200 {
    //                        callBack?(jsonData)
    //                        print("請求成功 \(String(describing: response.result.value))")
    //                    }else{
    //                        print("請求失敗 callBack 後端寫錯那種: \(response.debugDescription)")
    //                    }
                        
                        print("請求成功 \(String(describing: response.result.value))")
                        callBack?(jsonData)
                        
                    }else{
                        print("請求失敗 callBack onFailure那種: \(response.debugDescription)")
                    }
                }
        }
    
    
}






//
//class ApiHelper: NSObject {
//
//    //单例
//    static let sharedInstance = ApiHelper()
//
//    var alamofireManager:Alamofire.SessionManager!
////    let headers:[String:String] = ["Content-Type":"applicatino/json", "Content-Type":"application/x-www-form-urlencoded"]
//
//    fileprivate override init() {
//
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForResource = 20
//        alamofireManager = Alamofire.SessionManager(configuration: configuration)
//    }
//
//
//    func getDataUrl(url:String, param:Dictionary<String, Any>) ->Void  {
//
//        alamofireManager.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: ["Content-Type":"application/x-www-form-urlencoded"]).validate(statusCode: 200 ..< 500).responseJSON { (result) in
//            if result.result.isSuccess {
//                print("isSuccess")
//                let json = try! JSON(data: result.data!)
//
//                if let ssss = json.dictionary {
//                    print(ssss)
//                    if let aaa = ssss["data"]?.dictionary {
//                        print(aaa)
//                        if let bbb = aaa["riddles"]?.array {
//                            for obj in bbb {
//
//                            }
//                        }
//                    }
//                }
//
//
//                print("123123")
//
//            }else{
//                print("isFail")
//            }
//        }
//    }
//}


