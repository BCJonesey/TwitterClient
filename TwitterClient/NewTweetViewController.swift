//
//  NewTweetViewController.swift
//  TwitterClient
//
//  Created by Ben Jones on 10/30/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var actionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    
    var success : ((Tweet)->())?
    var created : ((Tweet)->())?
    var failure : (()->())?
    var replyTo : Tweet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetButton.layer.cornerRadius = 10;
        tweetButton.backgroundColor = TwitterColor.blue
        tweetButton.tintColor = TwitterColor.white
        tweetButton.setTitleColor(TwitterColor.white, for: .normal)
        
        actionView.backgroundColor = TwitterColor.extraExtraLightGrey
        characterCountLabel.textColor = TwitterColor.extraLightGrey
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        if let replyTo = self.replyTo {
            textView.text = "@\(replyTo.user.screenName)"
        }
        
        User.getCurrentUser { (user:User) in
            self.userImage.setImageWith(user.profileImageUrl)
        }
        
        self.updateCount()
        
        textView.delegate = self
        textView.becomeFirstResponder()
        
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
        TwitterAPIManager.shared.createTweet(status: textView.text ?? "", reply: nil, success: { (tweet:Tweet) in
            print("tweet created")
            print(tweet.id)
            }) { 
                print("fail")
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 1, animations: {
                self.actionViewBottomConstraint.constant = keyboardSize.height
                self.view.layoutIfNeeded()
            })
        }
        
    }
    

    
    func updateCount() {
        let count = 140 - textView.text.characters.count
        self.characterCountLabel.text = "\(count)"
        if(count < 0){
            self.characterCountLabel.textColor = TwitterColor.red
        }else{
            self.characterCountLabel.textColor = TwitterColor.extraLightGrey
        }
    }
    
    

}

extension NewTweetViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.updateCount()
    }
}
