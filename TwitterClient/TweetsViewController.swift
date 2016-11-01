//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Ben Jones on 10/29/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
    var tweets:[Tweet] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //#1DA1F2
        
        self.navigationController?.navigationBar.tintColor = TwitterColor.blue
        self.navigationController?.navigationBar.barTintColor = TwitterColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "twitterLogo"))
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(UINib(nibName: "TweetTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TweetTableViewCell")
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getData(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        TwitterAPIManager.shared.login(controller: self,success: {
            self.getData(refreshControl: nil)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(refreshControl: UIRefreshControl?){
        TwitterAPIManager.shared.getTimline(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                refreshControl?.endRefreshing()
            }
        })
    }

    @IBAction func logOut(_ sender: AnyObject) {
        TwitterAPIManager.shared.logOut()
        TwitterAPIManager.shared.login(controller: self,success: {
            self.getData(refreshControl: nil)
        })
    }
    
    @IBAction func newTweetButtonPressed(_ sender: AnyObject) {
        let newTweetViewController = NewTweetViewController(replyTo: nil)
        self.present(newTweetViewController, animated: true, completion: nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let tweet = sender as? Tweet {
            if let tweetController = segue.destination as? TweetViewController {
                tweetController.tweet = tweet
                
            }
            
        }
    }
 

}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath as IndexPath) as! TweetTableViewCell
        
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        //cell.updates
        cell.repaint()
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowTweet", sender: tweets[indexPath.row])
    }
    
}

extension TweetsViewController: TweetTableViewCellDelegate{
    func tweetTableViewCellDidTriggerReply(cell: TweetTableViewCell) {
        let newTweetViewController = NewTweetViewController(replyTo: cell.tweet)
        self.present(newTweetViewController, animated: true, completion: nil)
    }
}
