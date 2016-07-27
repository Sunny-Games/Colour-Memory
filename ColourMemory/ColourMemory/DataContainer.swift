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
    
    convenience init(theName : String, score : Int) {
        self.init()
        self.name = theName
        self.score = score
    }
   
    override init() {
         super.init()
    }
}

private let LocalScoreTable = TableWith("LocalScoreTable", type: UserScore.self, primaryKey: "name", dbName: "LocalScoreTable")

class DataContainer: NSObject {
    static let sharedIntance = DataContainer()
    
    func storeScore(score : Int, name : String){
        let one = UserScore(theName: name, score: score)
        LocalScoreTable.save(one)
    }
}