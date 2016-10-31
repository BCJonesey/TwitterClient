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
        
        self.navigationController?.navigationBar.barTintColor = TwitterColor.blueColor
        self.navigationController?.navigationBar.isTranslucent = false
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(UINib(nibName: "TweetTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TweetTableViewCell")
        
        
        TwitterAPIManager.shared.login(controller: self,success: {
            self.getData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(){
        TwitterAPIManager.shared.getTimline(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
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
        
        cell.tweet = tweets[indexPath.row]
        cell.repaint()
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowTweet", sender: tweets[indexPath.row])
    }
    
}
