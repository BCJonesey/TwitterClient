//
//  HamburgerViewController.swift
//  TwitterClient
//
//  Created by Ben Jones on 11/6/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet var topLevelView: UIView!
    
    

    @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
    
    var menuViewController: UIViewController!{
        didSet{
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController!{
        didSet(oldContentViewController){
            if(oldContentViewController != nil){
                
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            self.contentViewLeadingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    var originalLeftMargin : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onContentPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: topLevelView)
        let velocity = sender.velocity(in: topLevelView)
        
        
        if(sender.state == .began){
            originalLeftMargin = contentViewLeadingConstraint.constant
        }else if(sender.state == .changed){
            contentViewLeadingConstraint.constant = originalLeftMargin + translation.x
        }else if(sender.state == .ended){
            
            UIView.animate(withDuration: 0.3, animations: {
                // User is opening the menu
                if(velocity.x > 0){
                    self.contentViewLeadingConstraint.constant = self.topLevelView.frame.size.width - 50
                }
                    //user is closing the menu
                else{
                    self.contentViewLeadingConstraint.constant = 0
                }
            })
        }
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
