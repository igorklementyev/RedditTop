//
//  RedditTopEntity.swift
//  RedditTop
//
//  Created by Igor Klementyev on 7/15/18.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation

struct RedditTopEntity{
    let title: String
    let author: String
    let created: Date
    let commentsNumber: Int
    let thumbnailUrl: String?
    let imageUrl: String?
    
    func hoursAgo() -> String{
        let date = Date()
        let timeInterval = date.timeIntervalSince(created)
        
        let hours = Int(timeInterval/3600.0); //3600 seconds in 1 hours
        
        return String(hours)
    }
}
