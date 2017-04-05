//
//  SearchMovieNetTask.swift
//  VisaMovie
//
//  Created by Jiao on 23/7/16.
//  Copyright © 2016 Jiao. All rights reserved.
//

import UIKit

class UploadUserScoreNetTask: BaseNetTask {
    var name : String?
    var score : Int?
 
    override func uri() -> String!
    {
        return "new"
    }
    
    override func query() -> [AnyHashable: Any]!{
        var dic = Dictionary<String , Any>()
        if let tmp = name {
            dic["name"] = tmp
        }
        if let tmp = score {
            dic["score"] = tmp
        }
        return dic
    }

}
