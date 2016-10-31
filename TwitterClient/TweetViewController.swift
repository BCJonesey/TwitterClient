//
//  TweetViewController.swift
//  TwitterClient
//
//  Created by Ben Jones on 10/30/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var likeButton: AnimatedUIButton!
    var tweet : Tweet?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        likeButton.imageColorOn = TwitterColor.redColor
        likeButton.addTarget(self, action: #selector(likeButtonPressed(sender:)), for: .touchUpInside)
        likeButton.isSelected = tweet?.favorited ?? false
        
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
    
    func likeButtonPressed(sender: AnimatedUIButton) {
        if sender.isSelected {
            // deselect
            sender.deselect()
        } else {
            // select with animation
            sender.select()
            tweet?.favorite(success: {
                print("faved")
                }, failure: {
                    print("failed")
            })
        }
    }
    
    @IBAction func replyButtonPressed(_ sender: AnyObject) {
        let newTweetViewController = NewTweetViewController(replyTo: tweet)
        self.present(newTweetViewController, animated: true, completion: nil)
    }
    
    @IBAction func retweetButtonPressed(_ sender: AnyObject) {
        
    }

}
