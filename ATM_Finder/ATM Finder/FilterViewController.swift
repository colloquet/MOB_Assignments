//
//  FilterViewController.swift
//  ATM Finder
//
//  Created by Colloque Tsui on 19/08/2015.
//  Copyright (c) 2015 Colloque Tsui. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {
    
    var banks:[String] = []
    var selectedBanks:[String] = []
    var defaults = NSUserDefaults.standardUserDefaults()
    var language = ""


    @IBAction func selectAllClicked(sender: AnyObject) {
        selectedBanks = banks
        tableView.reloadData()
    }
    
    @IBAction func removeAllClicked(sender: AnyObject) {
        selectedBanks = []
        tableView.reloadData()
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
        
        let range = Range(start: language.startIndex, end: advance(language.startIndex, 2))
        
        language = language.substringWithRange(range)
        
        if let defaultBanks = defaults.objectForKey("banks_\(language)") as? [String] {
            banks = defaultBanks
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return banks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bankCell") as! UITableViewCell
        
        let bank = banks[indexPath.row]
        
        cell.textLabel?.text = banks[indexPath.row]
        
        if contains(selectedBanks, bank) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let bank = banks[indexPath.row]
        if (cell!.accessoryType == UITableViewCellAccessoryType.Checkmark) {
            cell!.accessoryType = UITableViewCellAccessoryType.None
            // delete object
            selectedBanks = selectedBanks.filter { (currentOption) in currentOption != bank}
            println(selectedBanks)
        } else {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedBanks.append(banks[indexPath.row])
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
