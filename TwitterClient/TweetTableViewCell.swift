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
}

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteButton: AnimatedUIButton!
    @IBOutlet weak var retweetButton: AnimatedUIButton!
    @IBOutlet weak var replyButton: AnimatedUIButton!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var tweetBody: UILabel!
    var tweet : Tweet?
    weak var delegate : TweetTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favoriteButton.imageColorOn = TwitterColor.red
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed(sender:)), for: .touchUpInside)
        replyButton.addTarget(self, action: #selector(replyButtonPressed(sender:)), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(retweetButtonPressed(sender:)), for: .touchUpInside)
        retweetButton.imageColorOn = TwitterColor.green
        
                
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func favoriteButtonPressed(sender: AnimatedUIButton) {
        
        if sender.isSelected {
            // deselect
            sender.deselect()
            tweet?.destroyFavorite()
        } else {
            // select with animation
            sender.select()
            tweet?.favorite()
        }
        favoriteCount.text = "\((tweet?.favoriteCount)!)"
    }
    
    func retweetButtonPressed(sender: AnimatedUIButton) {
        
        if sender.isSelected {
            // deselect
            sender.deselect()
            tweet?.destroyRetweet()
        } else {
            // select with animation
            sender.select()
            tweet?.retweet()
        }
        retweetCount.text = "\((tweet?.retweetCount)!)"
    }
    
    func replyButtonPressed(sender: AnimatedUIButton) {
        delegate?.tweetTableViewCellDidTriggerReply(cell: self)
    }
    
    func repaint() {
        if let tweet = self.tweet{
            
                
            self.timeText.text = tweet.displayTimeSinceCreated
            self.tweetBody.text = tweet.text
            DispatchQueue.main.async {
            self.userImage.setImageWith(self.tweet!.user.profileImageUrl)
            
            self.userImage.layer.cornerRadius = 5.0
            self.userImage.clipsToBounds = true
            }
            
            
            
           
            self.userName.text = tweet.user.name
            self.retweetCount.text = "\(tweet.retweetCount)"
            self.favoriteCount.text = "\(tweet.favoriteCount)"
            print("ben fav: \(tweet.favorited)")
            self.favoriteButton.isSelected = tweet.favorited
            print("ben fav: \(tweet.retweeted)")
            self.retweetButton.isSelected = tweet.retweeted
            
            self.layoutIfNeeded()
            self.updateConstraintsIfNeeded()
            self.replyButton.updateLayers()
            self.retweetButton.updateLayers()
            self.favoriteButton.updateLayers()
            
            
        }
        
    }
    
}
