//
//  SettingsViewController.swift
//  ATM Finder
//
//  Created by Colloque Tsui on 19/8/15.
//  Copyright (c) 2015 Colloque Tsui. All rights reserved.
//

import UIKit


class SettingsViewController: UITableViewController {

    var selectedBanks:[String] = []
    var banks:[String] = []
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var language = ""
    var languageCode = ""
    
    @IBAction func closeOptions(exitSegue: UIStoryboardSegue) {
    }
    
    @IBAction func doneOptions(exitSegue: UIStoryboardSegue) {
        let optionsViewController = exitSegue.sourceViewController as! FilterViewController
        
        selectedBanks = optionsViewController.selectedBanks
        
        defaults.setObject(selectedBanks, forKey: "userBanks_\(languageCode)")
        defaults.synchronize()
        
        println(NSUserDefaults.standardUserDefaults().objectForKey("userBanks_\(languageCode)") as? [String])
        
        println(language)

    }
    
    @IBAction func feedbackButtonClick(sender: AnyObject) {
//        Instabug.invokeBugReporter()
        Instabug.invokeFeedbackSender()
    }
    
    @IBAction func iconsLinkButtonClick(sender: AnyObject) {
        var url : NSURL
        url = NSURL(string: "https://icons8.com/")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        if let userLanguage = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages") as? String {
            language = userLanguage
        } else {
            language = NSLocale.preferredLanguages()[0] as! String
            
            
            defaults.setObject([language], forKey: "AppleLanguages")
            defaults.synchronize()
        }
        
        println(language)
        
        let range = Range(start: language.startIndex, end: advance(language.startIndex, 2))
        
        languageCode = language.substringWithRange(range)
        
        if let userBanks = defaults.objectForKey("userBanks_\(languageCode)") as? [String] {
            selectedBanks = userBanks
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
//        return 2
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue.identifier == "toFilter") {
            let navVC = (segue.destinationViewController as! UINavigationController)
            let dvc = navVC.viewControllers.first as! FilterViewController
            dvc.selectedBanks = selectedBanks
        }
        
        if (segue.identifier == "toLanguageSelection") {
            let dvc = (segue.destinationViewController as! LanguageTableViewController)
            dvc.language = language
        }
    }

}
