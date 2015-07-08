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
    var firstValue:Double? = 0
    var result:Double? = 0
    var currentValue:Double? = 0
    var lastOperator:String? = ""
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
            var display:Double? = (displayLabel.text!.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil) as NSString).doubleValue
            
            currentValue = display
            
            displayLabel.text = fmt.stringFromNumber(display!)
        }
    }
    
    @IBAction func dotClick(sender: UIButton) {
        if shouldReplace == false {
            displayLabel.text = displayLabel.text! + sender.currentTitle!
        }
    }
    
    @IBAction func negativeClick(sender: AnyObject) {
        result = (displayLabel.text! as NSString).doubleValue * -1
        currentValue = currentValue! * -1
        displayLabel.text = String(format: "%g", result!)
    }
    
    @IBAction func clearClick(sender: AnyObject) {
        firstValue = 0
        currentValue = 0
        displayLabel.text = "0"
        lastOperator = ""
    }
    
    @IBAction func numberClick(sender: AnyObject) {
        println(sender.currentTitle!)
        replaceOrAppend(sender.currentTitle!!)
    }
    
    @IBAction func equalButton(sender: AnyObject) {
        switch lastOperator! {
        case "+":
            doMath("+")
        case "−":
            doMath("-")
        case "×":
            doMath("×")
        case "÷":
            doMath("÷")
        default: break
        }
        shouldReplace = true
    }
    
    func doMath(sign:String) {
        let fmt = NSNumberFormatter()
        fmt.numberStyle = .DecimalStyle
        switch sign {
        case "+":
            result = firstValue! + currentValue!
        case "-":
            result = firstValue! - currentValue!
        case "×":
            result = firstValue! * currentValue!
        case "÷":
            result = firstValue! / currentValue!
        default: break
        }
        displayLabel.text = String(format: "%g", result!)
    }
    
    @IBAction func operatorClick(sender: UIButton) {
        
        if lastOperator == "" {
            lastOperator = "+"
        }
        
        if shouldReplace == false {
            switch lastOperator! {
            case "+":
                doMath("+")
            case "−":
                doMath("-")
            case "×":
                doMath("×")
            case "÷":
                doMath("÷")
            default: break
            }
        }
    
        lastOperator = sender.currentTitle!
        
        firstValue = result
        
        shouldReplace = true
        
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

