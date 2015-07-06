//
//  ViewController.swift
//  MOB-Midterm
//
//  Created by Colloque Tsui on 06/07/2015.
//  Copyright (c) 2015 Colloque Tsui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var shouldReplace:Bool = true
    var firstValue:Int? = 0
    var secondValue:Int? = 0
    var result:Int? = 0
    var currentValue:Int? = 0
    var method = ""
    
    @IBOutlet weak var displayLabel: UILabel!
    
    func replaceOrAppend(number:String) {
        if count(displayLabel.text!) < 11 {
            let fmt = NSNumberFormatter()
            fmt.numberStyle = .DecimalStyle
            
            if shouldReplace == true {
                displayLabel.text = number
            } else {
                displayLabel.text = displayLabel.text! + number
            }
            shouldReplace = false
            var display:Int? = displayLabel.text?.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).toInt()!
            
            currentValue = display
            
            displayLabel.text = fmt.stringFromNumber(display!)
        }
    }
    
    @IBAction func numberClick(sender: AnyObject) {
        println(sender.currentTitle!)
        replaceOrAppend(sender.currentTitle!!)
    }
    
    @IBAction func equalButton(sender: AnyObject) {

    }
    
    @IBAction func operatorClick(sender: AnyObject) {
        
        switch sender.currentTitle!! {
        case "+":
            if shouldReplace != true {
                secondValue = currentValue
                result = firstValue! + secondValue!
                displayLabel.text = String(result!)
                firstValue = result
                shouldReplace = true
            }
        case "−":
            if shouldReplace != true {
                secondValue = currentValue
                result = firstValue! - secondValue!
                displayLabel.text = String(result!)
                firstValue = result
                shouldReplace = true
            }
        case "×":
            if shouldReplace != true {
                secondValue = currentValue
                result = firstValue! * secondValue!
                displayLabel.text = String(result!)
                firstValue = result
                shouldReplace = true
            }
        case "÷":
            if shouldReplace != true {
                secondValue = currentValue
                result = firstValue! / secondValue!
                displayLabel.text = String(result!)
                firstValue = result
                shouldReplace = true
            }
        default: break
        }
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

