//
//  User.swift
//  TwitterClient
//
//  Created by Ben Jones on 10/29/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit

class User: NSObject {
    var id : String
    var name : String
    var screenName : String
    var originalDictionary : NSDictionary
    var profileImageUrl : URL
    var profileBannerUrl: URL
    var followerCount : NSNumber
    var friendCount : NSNumber
    var location : String
    
    
    
    init(_ data:NSDictionary) {
        self.originalDictionary = data
        self.name = data.value(forKey: "name") as! String
        self.id = data.value(forKey: "id_str") as! String
        self.screenName = data.value(forKey: "screen_name") as! String
        self.profileImageUrl = URL(string: (data.value(forKey: "profile_image_url_https") as! String).replacingOccurrences(of: "_normal", with: "_bigger"))!
        self.profileBannerUrl = URL(string: "\((data.value(forKey: "profile_banner_url") as? String) ?? "https://pbs.twimg.com/profile_banners/6253282/1431474710")/600x200")!
        self.followerCount = data.value(forKey: "followers_count") as! NSNumber
        self.friendCount = data.value(forKey: "friends_count") as! NSNumber
        self.location = (data.value(forKey: "location") as? String) ?? "The Internet"
        


    }
    
    class func getCurrentUser(success: ((User)->())?){
        // try to get the User from backup
        if let user = User.currentUser {
            success?(user)
        } else {
            TwitterAPIManager.shared.getCurrentUser(success: { (user:User) in
                currentUser = user
                success?(user)
            })
            
        }
        
    }
    class func clearCurrentUser(){
        currentUser = nil
    }
    
    private class var currentUser : User?{
        get{
            if let data = UserDefaults.standard.object(forKey: "currentUserData") as? Data {
                
                
                if let dict = try? JSONSerialization.jsonObject(with: data, options:[]) as! NSDictionary{
                    return User(dict)
                }else{
                    return nil
                }
            }
            return nil
        }
        set(user){
            if let user = user {
                if let data = try? JSONSerialization.data(withJSONObject: user.originalDictionary, options: []) {
                    UserDefaults.standard.set(data, forKey: "currentUserData")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "currentUserData")
            }
            UserDefaults.standard.synchronize()
        }
    }
}



/*
 {
 "id": 2244994945,
 "id_str": "2244994945",
 "name": "TwitterDev",
 "screen_name": "TwitterDev",
 "location": "Internet",
 "profile_location": null,
 "description": "Developer and Platform Relations @Twitter. We are developer advocates. We can't answer all your questions, but we listen to all of them!",
 "url": "https://t.co/66w26cua1O",
 "entities": {
 "url": {
 "urls": [
 {
 "url": "https://t.co/66w26cua1O",
 "expanded_url": "https://dev.twitter.com/",
 "display_url": "dev.twitter.com",
 "indices": [
 0,
 23
 ]
 }
 ]
 },
 "description": {
 "urls": []
 }
 },
 "protected": false,
 "followers_count": 429831,
 "friends_count": 1535,
 "listed_count": 999,
 "created_at": "Sat Dec 14 04:35:55 +0000 2013",
 "favourites_count": 1713,
 "utc_offset": -25200,
 "time_zone": "Pacific Time (US & Canada)",
 "geo_enabled": true,
 "verified": true,
 "statuses_count": 2588,
 "lang": "en",
 "status": //tweet
 "contributors_enabled": false,
 "is_translator": false,
 "is_translation_enabled": false,
 "profile_background_color": "FFFFFF",
 "profile_background_image_url": "http://abs.twimg.com/images/themes/theme1/bg.png",
 "profile_background_image_url_https": "https://abs.twimg.com/images/themes/theme1/bg.png",
 "profile_background_tile": false,
 "profile_image_url": "http://pbs.twimg.com/profile_images/530814764687949824/npQQVkq8_normal.png",
 "profile_image_url_https": "https://pbs.twimg.com/profile_images/530814764687949824/npQQVkq8_normal.png",
 "profile_banner_url": "https://pbs.twimg.com/profile_banners/2244994945/1396995246",
 "profile_link_color": "0084B4",
 "profile_sidebar_border_color": "FFFFFF",
 "profile_sidebar_fill_color": "DDEEF6",
 "profile_text_color": "333333",
 "profile_use_background_image": false,
 "has_extended_profile": false,
 "default_profile": false,
 "default_profile_image": false,
 "following": false,
 "follow_request_sent": false,
 "notifications": false,
 "translator_type": "regular"
 }
 
 */
