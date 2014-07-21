//
//  ViewController.swift
//  twitter-app-swifter
//
//  Created by Muya on 7/20/14.
//  Copyright (c) 2014 muya. All rights reserved.
//

import UIKit
import SwifteriOS

// inherits from UIViewController and implements the UITableViewDelegate & UITableViewDataSource protocols
class RecentTweets: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var stream : [JSONValue] = []
    
    @IBOutlet var tableView : UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // as defined in the protocol, we need to provid the number of rows in this table
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return stream.count
    }
    
    // another protocol method, allowing us to control the data created in each cell
    // note that UITableView has a ! at the end
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        //grab the data in the recentTweets array based on the index of the cell
        // tell the program what type of data it is so that we can drill into this generic object
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: nil)
        
        cell.textLabel.text = stream[indexPath.row]["text"].string
        return cell
    }
    
}

