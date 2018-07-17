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

class RedditTopEntityWrapperClass: NSObject, NSCoding {
    
    var redditTopEntity: RedditTopEntity?
    
    init(redditTopEntity: RedditTopEntity) {
        self.redditTopEntity = redditTopEntity
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: "title") as? String else { redditTopEntity = nil; super.init(); return nil }
        guard let author = aDecoder.decodeObject(forKey: "author") as? String else { redditTopEntity = nil; super.init(); return nil }
        guard let created = aDecoder.decodeObject(forKey: "created") as? Date else { redditTopEntity = nil; super.init(); return nil }
        let commentsNumber = aDecoder.decodeInteger(forKey: "commentsNumber")
        guard let thumbnailUrl = aDecoder.decodeObject(forKey: "thumbnailUrl") as? String? else { redditTopEntity = nil; super.init(); return nil }
        guard let imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String? else { redditTopEntity = nil; super.init(); return nil }
        redditTopEntity = RedditTopEntity(title: title, author: author, created: created, commentsNumber: commentsNumber, thumbnailUrl: thumbnailUrl, imageUrl: imageUrl)
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(redditTopEntity!.title, forKey: "title")
        aCoder.encode(redditTopEntity!.author, forKey: "author")
        aCoder.encode(redditTopEntity!.created, forKey: "created")
        aCoder.encode(redditTopEntity!.commentsNumber, forKey: "commentsNumber")
        aCoder.encode(redditTopEntity!.thumbnailUrl, forKey: "thumbnailUrl")
        aCoder.encode(redditTopEntity!.imageUrl, forKey: "imageUrl")
    }
}
