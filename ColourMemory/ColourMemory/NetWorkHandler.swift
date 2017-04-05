//
//  NetWorkWrapper.swift
//  VisaMovie
//
//  Created by jiao qing on 23/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

let BaseURL = "https://xuran-jiaoqing-findfriends.herokuapp.com/user_scores"

class NetWorkHandler: NSObject {
  static let sharedInstance = NetWorkHandler()
  
  let httpQueryStringManager : AFHTTPSessionManager = {
    let one = AFHTTPSessionManager(baseURL : URL(string: BaseURL))
    one.responseSerializer = AFHTTPResponseSerializer()
    return one
  }()
  
  lazy var httpJSONManager : AFHTTPSessionManager = {
    let one = AFHTTPSessionManager(baseURL : URL(string: BaseURL))
    one.requestSerializer = AFJSONRequestSerializer()
    return one
  }()
  
  func sendNetTask(_ task : BaseNetTask){
    var httpManager = httpQueryStringManager
    guard let wholeURL = task.uri() else { return }
    
    let successWrapper: (URLSessionDataTask, Any?) -> Void = {(wtask : URLSessionDataTask, wresponse : Any?) -> Void in
      DispatchQueue.main.async {
        task.success(wtask, wresponse as AnyObject)
      }
    }
    let failedWrapper: (URLSessionDataTask?, Error) -> Void = {(wtask : URLSessionDataTask?, werror : Error) -> Void in
      DispatchQueue.main.async {
        task.failed(wtask, werror as NSError)
      }
    }
    
    if task.method() == HTTPTaskMethod.post {
      httpManager = httpJSONManager
      httpManager.post(wholeURL, parameters: task.query(), progress: nil, success: successWrapper, failure: failedWrapper)
    }else{
      httpManager.get(wholeURL, parameters: task.query(), progress: nil, success: successWrapper, failure: failedWrapper)
    }
    
  }
}
