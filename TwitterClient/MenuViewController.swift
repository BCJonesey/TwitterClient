//
//  MenuViewController.swift
//  TwitterClient
//
//  Created by Ben Jones on 11/6/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit


class MenuViewController: UIViewController {

    var hamburgerViewController:HamburgerViewController!
    
    
    @IBOutlet weak var tableView: UITableView!
    let menuItems = ["Time Line", "Profile"]
    var contentViewControllers : [UIViewController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        contentViewControllers.append(storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController"))
        
        contentViewControllers.append(storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController"))
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        hamburgerViewController.contentViewController = contentViewControllers[0]
        
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

}

extension MenuViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = contentViewControllers[indexPath.row]
    }
    
}
