
import UIKit

class ThirdViewController: UIViewController {
  /*
  TODO six: Hook up the number input text field, button and text label to this class. When the button is pressed, a message should be printed to the label indicating whether the number is even.
  
  */
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func calculateEven(sender: AnyObject) {
        var input:Int! = numberTextField.text.toInt()
        // validation, probably not needed as the keyboard type is numberpad
        if input == nil {
            println("Please enter a number!")
            return
        }
        
        if input % 2 == 0 {
            label.text = "This is an even number!"
        } else {
            label.text = "This is not an even number!"
        }
    }
}
