//
//  GenreListNetTask.swift
//  VisaMovie
//
//  Created by Jiao on 23/7/16.
//  Copyright © 2016 Jiao. All rights reserved.
//

import UIKit

class ScoreListNetTask: BaseNetTask {
    override func uri() -> String!
    {
        return ""
    }
    
    static func parseResultToUserScoreList(array : NSArray) -> [UserScore] {
        var userList = [UserScore]()
        
        for one in array {
            if let dic = one as? NSDictionary {
                let oneUser = UserScore()
                if let tmp = dic["score"] as? Int{
                    oneUser.score = tmp
                }
                if let tmp = dic["name"] as? String{
                    oneUser.name = tmp
                }
                userList.append(oneUser)
            }
        }
        return userList
    }
    
}
