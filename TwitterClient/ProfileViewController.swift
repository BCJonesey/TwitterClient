//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Ben Jones on 11/7/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var topOfSegmentedControllMinDistance: NSLayoutConstraint!
    @IBOutlet weak var topOfImageConstraint: NSLayoutConstraint!
    var initialTopOfImageConstraint : CGFloat = 5.0
    var initialBottomProfiledistance : CGFloat = 75.0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var verifiedUserBadge: UIImageView!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var userHeaderImage: UIImageView!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var userImage: UIImageView!
    var user:User?{
        didSet{
            if let user = self.user {
                view.layoutIfNeeded()
                userImage.setImageWith(user.profileImageUrl)
                userHeaderImage.setImageWith(user.profileBannerUrl)
                userName.text = user.name
                userScreenName.text = "@\(user.screenName)"
                followerCount.text = "\(user.followerCount)"
                followingCount.text = "\(user.friendCount)"
                userLocation.text = user.location
                getData(refreshControl: nil)
            }
        }
    }
    var tweets:[Tweet] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(user == nil){
            User.getCurrentUser(success: { (currentUser:User) in
                self.user = currentUser
            })
        }
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(UINib(nibName: "TweetTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TweetTableViewCell")
        
        
        
        userImage.layer.borderWidth = 4.0
        userImage.layer.borderColor = TwitterColor.white.cgColor
        userImage.layer.cornerRadius = 5
        userImage.clipsToBounds = true
        
        segmentedControl.tintColor = TwitterColor.blue
        userScreenName.textColor = TwitterColor.darkGrey
        userLocation.textColor = TwitterColor.darkGrey
        followers.textColor = TwitterColor.darkGrey
        following.textColor = TwitterColor.darkGrey
        
        
        
        initialTopOfImageConstraint = topOfImageConstraint.constant
        
        
        initialBottomProfiledistance = userImage.frame.maxY - userHeaderImage.frame.maxY
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getData(refreshControl: UIRefreshControl?){
        let success = { (tweets:[Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.tableView.setContentOffset(CGPoint.zero, animated: false)
            // Tell the refreshControl to stop spinning
            refreshControl?.endRefreshing()
            
        }
        if(segmentedControl.selectedSegmentIndex == 0){
           TwitterAPIManager.shared.getTimeline(user:self.user,success: success)
        }else{
            TwitterAPIManager.shared.getFavoritesList(user: self.user!, success: success)
        }
        
    }
    
    @IBAction func userDidPanTableView(_ sender: UIPanGestureRecognizer) {
        print("pan")
    }
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        getData(refreshControl: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = TwitterColor.white
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath as IndexPath) as! TweetTableViewCell
        
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let tweetViewController = storyboard.instantiateViewController(withIdentifier: "TweetViewController") as! TweetViewController
        tweetViewController.tweet = tweets[indexPath.row]
        
        self.navigationController?.pushViewController(tweetViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
        
        
        userImage.alpha = ((userImage.frame.maxY - userHeaderImage.frame.maxY)/initialBottomProfiledistance)
        
        
        if ((scrollView.contentOffset.y > 0)&&(segmentedControl.frame.minY - userHeaderImage.frame.maxY) > topOfSegmentedControllMinDistance.constant) {
            topOfImageConstraint.constant = initialTopOfImageConstraint - scrollView.contentOffset.y
            
        } else if ((scrollView.contentOffset.y < 0)&&(topOfImageConstraint.constant < initialTopOfImageConstraint)) {
            topOfImageConstraint.constant = topOfImageConstraint.constant - scrollView.contentOffset.y
            
        }
    }
}

extension ProfileViewController: TweetTableViewCellDelegate{
    func tweetTableViewCellDidTriggerReply(cell: TweetTableViewCell) {
        let newTweetViewController = NewTweetViewController(replyTo: cell.tweet)
        self.present(newTweetViewController, animated: true, completion: nil)
    }
    func tweetTableViewCellDidTriggerProfileView(cell: TweetTableViewCell){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileViewController.user = cell.tweet?.user
        
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
    }
}
