//
//  TweetTableViewCell.swift
//  TwitterClient
//
//  Created by Ben Jones on 10/29/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var tweetBody: UILabel!
    @IBOutlet weak var retweetText: UILabel!
    @IBOutlet weak var retweetImage: UIImageView!
    var tweet : Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func repaint() {
        if let tweet = self.tweet{
            tweetBody.text = tweet.text
            userImage.af_setImage(withURL: tweet.user.profileImageUrl)
            userName.text = tweet.user.name
            userScreenName.text = "@\(tweet.user.screenName)"
            self.updateConstraintsIfNeeded()
        }
        
    }
    
}
