//
//  DataContainer.swift
//  ColourMemory
//
//  Created by jiao qing on 25/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class UserScore: NSObject {
    var name = ""
    var score : Int = 0
    var rank : Int = 0
    
    convenience init(theName : String, score : Int) {
        self.init()
        self.name = theName
        self.score = score
    }
    
    override init() {
        super.init()
    }
}

private let LocalScoreTable = TableWith("LocalScoreTable", type: UserScore.self, primaryKey: nil, dbName: "LocalScoreTable")

class DataContainer: NSObject {
    static let sharedIntance = DataContainer()
    
    func storeScore(_ score : Int, name : String){
        let one = UserScore(theName: name, score: score)
        LocalScoreTable.save(one)
        
        let vNetTask = UploadUserScoreNetTask()
        vNetTask.name = name
        vNetTask.score = score
        vNetTask.success = {(task : URLSessionDataTask, responseObject : AnyObject?) -> Void in
            print("upload successed")
        }
        vNetTask.failed = {(task : URLSessionDataTask?, error : NSError) -> Void in
            print(error.description)
        }
        NetWorkHandler.sharedInstance.sendNetTask(vNetTask)
    }
    
    func getAllScores(_ handler : @escaping ([UserScore]) -> Void){
        let vNetTask = ScoreListNetTask()
        vNetTask.success = {(task : URLSessionDataTask, responseObject : AnyObject?) -> Void in
            if let jsonData: Data = responseObject as? Data {
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options:[])
                    if let theArray = jsonArray as? NSArray{
                        handler(ScoreListNetTask.parseResultToUserScoreList(theArray))
                    }
                }
                catch {}
            }
        }
        vNetTask.failed = {(task : URLSessionDataTask?, error : NSError) -> Void in
            print(error.description)
            LocalScoreTable.queryAll(handler: handler)
        }
        NetWorkHandler.sharedInstance.sendNetTask(vNetTask)
    }
    
    func getHighScores(_ handler : @escaping ([UserScore]) -> Void, maxNumber : Int){
        let wrapper = {(users : [UserScore]) -> Void in
            var nusers = users.sorted(by: { $0.score > $1.score })
            
            if nusers.count <= maxNumber {
                self.countUserRank(&nusers)
                handler(nusers)
            }else{
                var ret : [UserScore] = Array(nusers[0...maxNumber])
                self.countUserRank(&ret)
                handler(ret)
            }
        }
        
        getAllScores(wrapper)
    }
    
    func countUserRank(_ users : inout [UserScore]){
        var rank = 1
        var preScore : Int?
        var cnt = 1
        for one in users {
            if let tmp = preScore {
                if one.score != tmp {
                    rank = cnt
                }
            }
            preScore = one.score
            
            one.rank = rank
            cnt += 1
        }
    }
    
    func getRanking(_ score : Int, handler : @escaping (Int) -> Void){
        let wrapper = {(users : [UserScore]) -> Void in
            var rank = 1
            for one in users {
                if one.score >= score {
                    rank += 1
                }
            }
            handler(rank)
        }
        getAllScores(wrapper)
    }
}
