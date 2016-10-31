//
//  AuthenticationViewController.swift
//  TwitterClient
//
//  Created by Ben Jones on 10/29/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit




class AuthenticationViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var urlProtocol = "bentwitter"
    var authUrl : URL
    var success : (String)->()
    var failure : ()->()
    
    init(authUrl: URL, success: @escaping (String)->(), failure: @escaping ()->()) {
        self.authUrl = authUrl
        self.success = success
        self.failure = failure
        super.init(nibName: "AuthenticationViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.delegate = self
        webView.loadRequest(URLRequest(url: authUrl))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        failure()
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AuthenticationViewController : UIWebViewDelegate{

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let query = request.url?.query {
            if(query.range(of: "oauth_verifier") != nil && query.range(of: "oauth_token") != nil) {
                success(query)
                dismiss(animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}
