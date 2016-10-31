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
    func getTimline(success:@escaping ([Tweet]) -> ()) {
        self.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask?, response:Any?) in
            let data = response as! [NSDictionary]
            success(Tweet.buildTweets(data))
            
        }) { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
        }
    }
    
    func favorite(tweet: Tweet, success: @escaping ()->(), failure: @escaping ()->()) {
        self.post("1.1/favorites/create.json", parameters: ["id":tweet.id], progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
             success()
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure()
        }
    }
    
    func retweet(tweet: Tweet, success: @escaping ()->(), failure: @escaping ()->()) {
        self.post("1.1/statuses/retweet/\(tweet.id).json", parameters: [:], progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure()
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
    
    
    
}


// Auth code
extension TwitterAPIManager {
    
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
    static let blueColor = UIColor(red: 29/255, green: 161/256, blue: 242/256, alpha: 1)
    static let redColor = UIColor(red: 232/255, green: 28/256, blue: 79/256, alpha: 1)
    static let greenColor = UIColor(red: 25/255, green: 207/256, blue: 134/256, alpha: 1)
    /*
     Black
     HEX #14171A
     RGB 20 23 26
     CMYK 76 68 63 78
     PANTONE Black 7 C
     
     Dark Gray
     HEX #657786
     RGB 101 119 134
     CMYK 65 46 37 8
     PANTONE Cool Gray 9 C
     
     Light Gray
     HEX #AAB8C2
     RGB 170 184 194
     CMYK 34 20 18 0
     PANTONE Cool Gray 7 C
     
     Extra Light Gray
     HEX #E1E8ED
     RGB 225 232 237
     CMYK 10 4 4 0
     PANTONE Cool Gray 3 C
     
     Extra Extra Light Gray
     HEX #F5F8FA
     RGB 245 248 250
     CMYK 3 1 1 0
     PANTONE Cool Gray 1 C
     
     White
     HEX #FFFFFF
     RGB 255 255 255
     C
     */
    

}

