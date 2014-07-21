//
//  AuthViewController.swift
//  twitter-app-swifter
//
//  Created by Muya on 7/20/14.
//  Copyright (c) 2014 muya. All rights reserved.
//

// UIKit is our base for interacting with nibs, storyboards, and the app as a 

import UIKit //base for interacting with nibs, storyboards, and the app as a whole
import Accounts //gives us access to accounts authed in the phone's settings
import Social //allows us to interact with Twitter in limited way
import SwifteriOS //gives us more granular control for dealing with Twitter

// Assigned to the first UIViewController in Main.storyboard
class AuthViewController: UIViewController {
    // default to using the ios account framework for handling twitter auth
    let useACAccount = true
    
    //our custom button action
    @IBAction func doTwitterLogin(sender: AnyObject) {
        // all errors should be caught and aler the user with user-friendly text
        let failureHandler: ((NSError) -> Void) = {
            error in
            
            self.alert(error.localizedDescription)
        }
        
        if useACAccount{
            let accountStore = ACAccountStore()
            let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            // prompt the user for permission to their twitter account stored in the phone's settings
            accountStore.requestAccessToAccountsWithType(accountType){
                granted, error in
                
                if granted{
                    let twitterAccounts = accountStore.accountsWithAccountType(accountType)
                    
                    if twitterAccounts{
                        if twitterAccounts.count == 0{
                            self.alert("There are no Twitter accounts configured. You can add or create a Twitter account in Settings.")
                        }
                        else{
                            let twitterAccount = twitterAccounts[0] as ACAccount
                            let swifter = Swifter(account: twitterAccount)
                            self.fetchTwitterHomeStream(swifter)
                        }
                    }
                    else{
                        self.alert("There are no Twitter accounts configured. You can add or create a Twitter account in Settings.")
                    }
                }
            }
        }
        //let's do with Swifter
        else{
            let swifter = Swifter(
                consumerKey: "RErEmzj7ijDkJr60ayE2gjSHT",
                consumerSecret: "SbS0CHk11oJdALARa7NDik0nty4pXvAxdt7aj0R5y1gNzWaNEx"
            )
            
            swifter.authorizeWithCallbackURL(
                NSURL(string: "swifter://success"),
                success: {
                    accessToken, response in
                    self.alert("Successfully authorized with App API")
                    self.fetchTwitterHomeStream(swifter)
                }, failure: failureHandler)
        }
    }
    
    //create alert function that we can re-use
    func alert(message: String){
        // iOS8 way of doing alerts
        var alert = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //fetch user's home timeline
    func fetchTwitterHomeStream(swifter: Swifter){
        let failureHandler: ((NSError) -> Void) = {
            error in
            self.alert(error.localizedDescription)
        }
        
        swifter.getStatusesHomeTimelineWithCount(
            20,
            sinceID: nil,
            maxID: nil,
            trimUser: true,
            contributorDetails: false,
            includeEntities: true,
            success: {
                (statuses: [JSONValue]?) in
                
                //stream loaded ok, let's create and push the tabl view
                let recentTweets = self.storyboard.instantiateViewControllerWithIdentifier("RecentTweets") as RecentTweets
                
                if statuses{
                    //we have a statuses enumerable now
                    // let's assign it to our RecentTweets Class and present the view
                    recentTweets.stream = statuses!
                    self.presentViewController(recentTweets, animated: true, completion: nil)
                }
            }, failure: failureHandler)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

