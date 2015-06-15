
import UIKit

class SecondViewController: UIViewController {
  
  //TODO five: Display the cumulative sum of all numbers added every time the ‘add’ button is pressed. Hook up the label, text box and button to make this work.
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var sumLabel: UILabel!
    
    var sum = 0
    
    @IBAction func addButtonClick(sender: AnyObject) {
        var input:Int! = numberTextField.text.toInt()
        // validation, probably not needed as the keyboard type is numberpad
        if input == nil {
            println("Please enter a number!")
            return
        }
        sum += input
        sumLabel.text = String(sum)
    }
    
}
