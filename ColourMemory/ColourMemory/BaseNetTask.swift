//
//  BaseNetTask.swift
//  VisaMovie
//
//  Created by jiao qing on 23/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

enum HTTPTaskMethod {
    case get
    case post
}

class BaseNetTask: NSObject {
    var success = {(task : URLSessionDataTask, response : AnyObject?) -> Void in }
    var failed = {(task : URLSessionDataTask?, error : NSError) -> Void in }
    
    func uri() -> String!
    {
        return ""
    }
    
    func method() -> HTTPTaskMethod
    {
        return HTTPTaskMethod.get
    }
    
    func query() -> [AnyHashable: Any]!
    {
        return Dictionary<String , AnyObject>()
    }
    
    func files() -> [AnyHashable: Any]? {
        return nil
    }
}
