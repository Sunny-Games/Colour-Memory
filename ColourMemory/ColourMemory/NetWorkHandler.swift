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
        let one = AFHTTPSessionManager(baseURL : NSURL(string: BaseURL))
        one.responseSerializer = AFHTTPResponseSerializer()
        return one
    }()
    
    lazy var httpJSONManager : AFHTTPSessionManager = {
        let one = AFHTTPSessionManager(baseURL : NSURL(string: BaseURL))
        one.requestSerializer = AFJSONRequestSerializer()
        return one
    }()
    
    func sendNetTask(task : BaseNetTask){
        var httpManager = httpQueryStringManager
        let wholeURL = task.uri()
        
        let successWrapper = {(wtask : NSURLSessionDataTask, wresponse : AnyObject?) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                task.success(wtask, wresponse)
            }
        }
        let failedWrapper = {(wtask : NSURLSessionDataTask?, werror : NSError) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                task.failed(wtask, werror)
            }
        }
        
        if task.method() == HTTPTaskMethod.Post {
            httpManager = httpJSONManager
            httpManager.POST(wholeURL, parameters: task.query(), success: successWrapper, failure: failedWrapper)
        }else{
            httpManager.GET(wholeURL, parameters: task.query(), success: successWrapper, failure: failedWrapper)
        }
        
    }
}
