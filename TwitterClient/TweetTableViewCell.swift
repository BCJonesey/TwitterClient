//
//  TweetTableViewCell.swift
//  TwitterClient
//
//  Created by Ben Jones on 10/29/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit
import AFNetworking

protocol TweetTableViewCellDelegate: class {
    func tweetTableViewCellDidTriggerReply(cell: TweetTableViewCell)
    func tweetTableViewCellDidTriggerProfileView(cell: TweetTableViewCell)
}

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var tweetBody: UILabel!
    var tweet : Tweet?{
        didSet{
            repaint()
        }
    }
    weak var delegate : TweetTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed(sender:)), for: .touchUpInside)
        replyButton.addTarget(self, action: #selector(replyButtonPressed(sender:)), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(retweetButtonPressed(sender:)), for: .touchUpInside)
        
        
        favoriteButton.setImage(#imageLiteral(resourceName: "heart").withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.tintColor = TwitterColor.darkGrey
        replyButton.setImage(#imageLiteral(resourceName: "reply").withRenderingMode(.alwaysTemplate), for: .normal)
        replyButton.tintColor = TwitterColor.darkGrey
        retweetButton.setImage(#imageLiteral(resourceName: "retweet").withRenderingMode(.alwaysTemplate), for: .normal)
        retweetButton.tintColor = TwitterColor.darkGrey
        
        
        userImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userImagePressed))
        userImage.addGestureRecognizer(gestureRecognizer)
                
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func favoriteButtonPressed(sender: UIButton) {
        
        if tweet!.favorited {
            tweet?.destroyFavorite()
            favoriteButton.tintColor = TwitterColor.darkGrey
        } else {
            tweet?.favorite()
            favoriteButton.tintColor = TwitterColor.red
        }
        favoriteCount.text = "\((tweet?.favoriteCount)!)"
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
        retweetCount.text = "\((tweet?.retweetCount)!)"
    }
    
    func replyButtonPressed(sender: UIButton) {
        delegate?.tweetTableViewCellDidTriggerReply(cell: self)
    }
    
    func userImagePressed() {
        delegate?.tweetTableViewCellDidTriggerProfileView(cell: self)
    }
    
    func repaint() {
        if let tweet = self.tweet{
            
                
            self.timeText.text = tweet.displayTimeSinceCreated
            self.tweetBody.text = tweet.text
            userImage.setImageWith(tweet.user.profileImageUrl)
            
            
            self.userScreenName.text = "@\(tweet.user.screenName)"
            self.userImage.layer.cornerRadius = 5.0
            self.userImage.clipsToBounds = true
            
            
            
            
           
            self.userName.text = tweet.user.name
            self.retweetCount.text = "\(tweet.retweetCount)"
            self.favoriteCount.text = "\(tweet.favoriteCount)"
           
            
            if tweet.favorited{
                favoriteButton.tintColor = TwitterColor.red
            }
            
            if tweet.retweeted{
                retweetButton.tintColor = TwitterColor.green
            }
            
        }
        
    }
    
}
