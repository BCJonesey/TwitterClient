//
//  TwitterAPIManager.swift
//  TwitterClient
//
//  Created by Ben Jones on 10/29/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit
import BDBOAuth1Manager



class TwitterAPIManager: BDBOAuth1SessionManager {
    
    static let shared = TwitterAPIManager(baseURL: URL(string:"https://api.twitter.com")!, consumerKey: "XDiwLjK45rec3rN8nLv60mqLn", consumerSecret: "wSDvRtomSS6taGTSl8bFoOlVXXm0zIWvfdgEukTuFcAJGmlkPs")!
    
    
}

// Twitter REST API metheods
extension TwitterAPIManager {
    func getTimeline(user:User?,success:@escaping ([Tweet]) -> ()) {
        var parameters:[String:String] = [:]
        if let user = user {
            parameters["user_id"] = user.id
        }
        
        self.get("1.1/statuses/user_timeline.json", parameters: parameters, progress: nil, success: { (task:URLSessionDataTask?, response:Any?) in
            let data = response as! [NSDictionary]
            success(Tweet.buildTweets(data))
            
        }) { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
        }
    }
    // /
    func getFavoritesList(user: User, success:@escaping ([Tweet]) -> ()) {
        self.get("1.1/favorites/list.json", parameters: ["user_id":user.id], progress: nil, success: { (task:URLSessionDataTask?, response:Any?) in
            let data = response as! [NSDictionary]
            success(Tweet.buildTweets(data))
            
        }) { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
        }
    }
    
    func getMentionsList(success:@escaping ([Tweet]) -> ()) {
        
        self.get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask?, response:Any?) in
            let data = response as! [NSDictionary]
            success(Tweet.buildTweets(data))
            
        }) { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
        }
    }
    func getHomeTimeline(success:@escaping ([Tweet]) -> ()) {
        
        self.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask?, response:Any?) in
            let data = response as! [NSDictionary]
            success(Tweet.buildTweets(data))
            
        }) { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
        }
    }
    func favorite(tweet: Tweet) {
        
        self.post("1.1/favorites/create.json?id=\(tweet.id)", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let data = response as! NSDictionary
            print("fav created")
            print(data)
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            print("couldnt crate fav")
        }
    }
    func destroyFavorite(tweet: Tweet) {
        self.post("1.1/favorites/destroy.json?id=\(tweet.id)", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let data = response as! NSDictionary
            print("fav destroyed")
            print(data)
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            print("couldnt destroy fav")
        }
    }

    func retweet(tweet: Tweet) {
        self.post("1.1/statuses/retweet/\(tweet.id).json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let data = response as! NSDictionary
            print("retweet created")
            print(data)
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            print("couldnt create retweet")
        }
    }
    func destroyRetweet(tweet: Tweet) {
        self.post("1.1/statuses/unretweet/\(tweet.id).json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let data = response as! NSDictionary
            print("retweet destroyed")
            print(data)
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            print("couldnt destroy retweet")
        }
    }
    
    func createTweet(status: String, reply: Tweet?, success: @escaping (Tweet)->(), failure: @escaping ()->()){
        
        self.post("1.1/statuses/update.json", parameters: ["status":status,"in_reply_to_status_id":reply?.id], progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let data = response as! NSDictionary
            success(Tweet(data))
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure()
        }
    }
    
    func getCurrentUser(success: @escaping (User)->()){
        self.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask?, response:Any?) in
            if let data = response as? NSDictionary{
                
                success(User(data))
            }
            
            
            
        }) { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
        }
    }
    
    
    
}


// Auth code
extension TwitterAPIManager {
    func logOut()  {
        User.clearCurrentUser()
        self.deauthorize()
    }
    
    func login(controller:UIViewController, success:@escaping ()->()) {
        
        if(self.isAuthorized){
            success()
        }
        else {
            self.deauthorize()
            self.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: nil, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
                let ben = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)"
                let url = URL(string: ben.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
                let viewController = AuthenticationViewController(authUrl: url, success: { (query:String) in
                    self.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential.init(queryString: query), success: { (accessToken: BDBOAuth1Credential?) -> Void in
                        User.getCurrentUser(success: nil)
                        success()
                        }
                        , failure: { (error:Error?) -> Void in
                            print("Error!!: \(error?.localizedDescription)")
                    })
                    }, failure: {
                        print("user canceled auth")
                })
                controller.present(viewController, animated: true, completion: nil)
                
                }
                , failure: { (error: Error?) -> Void in
                    print("Error: \(error?.localizedDescription)")
                }
            )
        }
    }
    
    
    
}

class TwitterColor: NSObject {
    static let blue = UIColor(red: 29/255, green: 161/256, blue: 242/256, alpha: 1)
    static let red = UIColor(red: 232/255, green: 28/256, blue: 79/256, alpha: 1)
    static let green = UIColor(red: 25/255, green: 207/256, blue: 134/256, alpha: 1)
    static let black = UIColor(red: 20/255, green: 23/256, blue: 26/256, alpha: 1)
    static let darkGrey = UIColor(red: 101/255, green: 119/256, blue: 134/256, alpha: 1)
    static let lightGrey = UIColor(red: 170/255, green: 232/256, blue: 237/256, alpha: 1)
    static let extraLightGrey = UIColor(red: 225/255, green: 184/256, blue: 194/256, alpha: 1)
    static let extraExtraLightGrey = UIColor(red: 245/255, green: 248/256, blue: 250/256, alpha: 1)
    static let white = UIColor.white
}

