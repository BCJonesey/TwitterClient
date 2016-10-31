//
//  Tweet.swift
//  TwitterClient
//
//  Created by Ben Jones on 10/29/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text:String
    var user:User
    var favorited:Bool = false
    var id:String
    var createdAt : Date?
    
    init(_ data:NSDictionary) {
        self.text = data.value(forKey: "text") as! String
        self.user = User(data.value(forKey: "user") as! NSDictionary)
        self.favorited = data.value(forKey: "favorited") as! Bool
        self.id = data.value(forKey: "id_str") as! String

        let dateFormatter = DateFormatter()
        // "Tue Aug 28 21:16:23 +0000 2012"
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        self.createdAt = dateFormatter.date(from: data.value(forKey: "created_at")
 as! String)
        
       
    }
    var displayTimeSinceCreated: String {
        if let createdAt = self.createdAt {
            let dateComponentsFormatter = DateComponentsFormatter()
            dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
            dateComponentsFormatter.maximumUnitCount = 1
            dateComponentsFormatter.unitsStyle = .abbreviated
            return dateComponentsFormatter.string(from: createdAt, to: Date()) ?? ""
        }
        return ""
    }
    
    func favorite(success:  @escaping () -> (), failure: @escaping () -> ()) {
        TwitterAPIManager.shared.favorite(tweet: self, success: success, failure: failure)
    }
    func retweet(success:  @escaping () -> (), failure: @escaping () -> ()) {
        TwitterAPIManager.shared.retweet(tweet: self, success: success, failure: failure)
    }

}

extension Tweet {
    class func buildTweets(_ dataArray:[NSDictionary]) -> [Tweet]{
        return dataArray.map { (data:NSDictionary) -> Tweet in
            return Tweet(data)
        }
    }
}

/*
 {
 "coordinates": null,
 "truncated": false,
 "created_at": "Tue Aug 28 21:16:23 +0000 2012",
 "favorited": false,
 "id_str": "240558470661799936",
 "in_reply_to_user_id_str": null,
 "user": //user
 "entities": {
 "urls": [
 
 ],
 "hashtags": [
 
 ],
 "user_mentions": [
 
 ]
 },
 "contributors": null,
 "id": 240558470661799936,
 "retweet_count": 0,
 "in_reply_to_status_id_str": null,
 "geo": null,
 "retweeted": false,
 "in_reply_to_user_id": null,
 "place": null,
 "source": "OAuth Dancer Reborn",
 "in_reply_to_screen_name": null,
 "in_reply_to_status_id": null
 }
 */
