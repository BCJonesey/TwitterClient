//
//  TweetViewController.swift
//  TwitterClient
//
//  Created by Ben Jones on 10/30/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    var tweet : Tweet?{
        didSet{
            if let tweet = tweet {
                view.layoutIfNeeded()
                tweetText.text = tweet.text
                retweetNumber.text = "\(tweet.retweetCount)"
                favNumber.text = "\(tweet.favoriteCount)"
                userName.text = tweet.user.name
                userScreenName.text = "@\(tweet.user.screenName)"
                
                userImage.setImageWith(tweet.user.profileImageUrl)
                
                if tweet.favorited{
                    favoriteButton.tintColor = TwitterColor.red
                }
                
                if tweet.retweeted{
                    retweetButton.tintColor = TwitterColor.green
                }
                
            }
            
        }
    }
    
    
    @IBOutlet weak var favNumber: UILabel!
    @IBOutlet weak var retweetNumber: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tweetText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed(sender:)), for: .touchUpInside)
        replyButton.addTarget(self, action: #selector(replyButtonPressed(sender:)), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(retweetButtonPressed(sender:)), for: .touchUpInside)
        
        favoriteButton.setImage(#imageLiteral(resourceName: "heart").withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.tintColor = TwitterColor.darkGrey
        replyButton.setImage(#imageLiteral(resourceName: "reply").withRenderingMode(.alwaysTemplate), for: .normal)
        replyButton.tintColor = TwitterColor.darkGrey
        retweetButton.setImage(#imageLiteral(resourceName: "retweet").withRenderingMode(.alwaysTemplate), for: .normal)
        retweetButton.tintColor = TwitterColor.darkGrey
        
        
        
            
        self.userImage.layer.cornerRadius = 5.0
        self.userImage.clipsToBounds = true
        userImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userImagePressed))
        userImage.addGestureRecognizer(gestureRecognizer)
            
        
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func favoriteButtonPressed(sender: UIButton) {
        
        if tweet!.favorited {
            tweet?.destroyFavorite()
            favoriteButton.tintColor = TwitterColor.darkGrey
        } else {
            tweet?.favorite()
            favoriteButton.tintColor = TwitterColor.red
        }
        favNumber.text = "\((tweet?.favoriteCount)!)"
    }
    
    func retweetButtonPressed(sender: UIButton) {
        
        if tweet!.retweeted {
            tweet?.destroyRetweet()
            retweetButton.tintColor = TwitterColor.darkGrey
        } else {
            tweet?.retweet()
            retweetButton.tintColor = TwitterColor.green
        }
        retweetButton.tintColor = TwitterColor.green
        retweetNumber.text = "\((tweet?.retweetCount)!)"
    }
    
    func replyButtonPressed(sender: UIButton) {
        let newTweetViewController = NewTweetViewController(replyTo: tweet)
        self.present(newTweetViewController, animated: true, completion: nil)
    }
    

    
    @IBAction func retweetButtonPressed(_ sender: AnyObject) {
        
    }
    
    func userImagePressed(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileViewController.user = tweet?.user
        
        self.navigationController?.pushViewController(profileViewController, animated: true)

    }
    
}
