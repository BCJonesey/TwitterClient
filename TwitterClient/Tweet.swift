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
    var favorited:Bool
    var favoriteCount : NSNumber = 0
    var id:String
    var createdAt : Date?
    var retweetCount : NSNumber = 0
    var retweeted : Bool
    
    init(_ data:NSDictionary) {
        print("ben jones\(data.value(forKey: "favorited") as! Bool)")
        self.text = data.value(forKey: "text") as! String
        self.user = User(data.value(forKey: "user") as! NSDictionary)
        self.favorited = data.value(forKey: "favorited") as! Bool
        self.favoriteCount = (data.value(forKey: "favorite_count") as? NSNumber) ?? 0
        self.id = data.value(forKey: "id_str") as! String
        self.retweetCount = (data.value(forKey: "retweet_count") as? NSNumber) ?? 0
        self.retweeted = data.value(forKey: "retweeted") as! Bool

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
    
    func destroyFavorite() {
        TwitterAPIManager.shared.destroyFavorite(tweet: self)
        if(favorited){
            favorited = false
            favoriteCount = NSNumber(value: favoriteCount.intValue - 1)
            
        }
    }
    func favorite() {
        TwitterAPIManager.shared.favorite(tweet: self)
        if(!favorited){
            favorited = true
            favoriteCount = NSNumber(value: favoriteCount.intValue + 1)
        }
    }
    func retweet() {
        TwitterAPIManager.shared.retweet(tweet: self)
        if(!favorited){
            retweeted = true
            retweetCount = NSNumber(value: retweetCount.intValue + 1)
        }
    }
    func destroyRetweet() {
        TwitterAPIManager.shared.destroyRetweet(tweet: self)
        if(favorited){
            retweeted = false
            retweetCount = NSNumber(value: retweetCount.intValue - 1)
        }
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
