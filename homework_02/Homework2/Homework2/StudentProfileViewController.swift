//
//  StudentProfileViewController.swift
//  Homework2
//
//  Created by Kannan Chandrasegaran on 25/6/15.
//  Copyright (c) 2015 Kannan Chandrasegaran. All rights reserved.
//

import UIKit

class StudentProfileViewController: UIViewController {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var averageScoreLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    var student:Student = Student()
    
    func averageScore(scores:[Int]) -> Double {
        var sum:Double = 0
        var average:Double = 0
        
        for score in scores {
            sum += Double(score)
        }
        
        average = sum / Double(scores.count)
        
        return average
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullNameLabel.text = student.firstName.capitalizedString + " " + student.lastName.capitalizedString
        ageLabel.text = "Age: " + String(student.age)
        averageScoreLabel.text = "Average score: " + averageScore(student.scores).description
        if let phoneNumber = student.phoneNumber {
            phoneNumberLabel.text = "Phone number: " + String(phoneNumber)
        } else {
            phoneNumberLabel.text = ""
        }
        let url = NSURL(string: student.profilePicURL)
        let data = NSData(contentsOfURL: url!)
        if let data = data {
            profilePic.image = UIImage(data: data)
        }
        
        // crop the profile image in circle
        profilePic.layer.masksToBounds = false
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
