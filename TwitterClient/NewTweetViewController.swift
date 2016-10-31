//
//  NewTweetViewController.swift
//  TwitterClient
//
//  Created by Ben Jones on 10/30/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var success : ((Tweet)->())?
    var created : ((Tweet)->())?
    var failure : (()->())?
    var replyTo : Tweet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let replyTo = self.replyTo {
            textView.text = "@\(replyTo.user.screenName)"
        }
    }
    
    init(replyTo: Tweet?) {
        self.replyTo = replyTo
        super.init(nibName: "NewTweetViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
  
    @IBAction func tweetButtonPressed(_ sender: AnyObject) {
        print(textView.text)
        TwitterAPIManager.shared.createTweet(status: textView.text, reply: nil, success: { (tweet:Tweet) in
            print("tweet created")
            print(tweet.id)
            }) { 
                print("fail")
        }
        dismiss(animated: true, completion: nil)
        
    }

}
