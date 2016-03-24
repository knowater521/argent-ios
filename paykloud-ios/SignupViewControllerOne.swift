//
//  SignupViewControllerOne.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 2/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import UIColor_Hex_Swift
import SVProgressHUD
import SIAlertView

class SignupViewControllerOne: UIViewController, UITextFieldDelegate {

    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var continueButton: UIButton!
    
    let firstNameTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let lastNameTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let dobTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    var dobDay:String = ""
    var dobMonth:String = ""
    var dobYear:String = ""

    //Changing Status Bar
    override public func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        
        firstNameTextField.becomeFirstResponder()

        var stepButton = UIBarButtonItem(title: "1/4", style: UIBarButtonItemStyle.Plain, target: nil, action: "")
        navigationItem.rightBarButtonItem = stepButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGrayColor()
        
        self.continueButton.enabled = false
        // Allow continue to be clicked
        Timeout(0.3) {
            SVProgressHUD.dismiss()
            self.continueButton.enabled = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()

        addToolbarButton()
        
        // Focuses view controller on first name text input
        firstNameTextField.becomeFirstResponder()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // Tint back button to gray
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
        title = ""
        
        // Inherit UITextField Delegate, this is used for next and join on keyboard
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.dobTextField.delegate = self
        
        continueButton.layer.cornerRadius = 0
        continueButton.backgroundColor = UIColor(rgba: "#38a4f9")
        
        // Programatically set the input fields
        firstNameTextField.tag = 89
        firstNameTextField.textAlignment = NSTextAlignment.Center
        firstNameTextField.borderActiveColor = UIColor(rgba: "#FFF")
        firstNameTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        firstNameTextField.backgroundColor = UIColor.clearColor()
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.placeholderColor = UIColor.grayColor()
        firstNameTextField.textColor = UIColor.grayColor()
        firstNameTextField.autocapitalizationType = UITextAutocapitalizationType.Words
        firstNameTextField.autocorrectionType = UITextAutocorrectionType.No
        firstNameTextField.keyboardType = UIKeyboardType.Default
        firstNameTextField.returnKeyType = UIReturnKeyType.Next
        firstNameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        firstNameTextField.frame.origin.y = screenHeight*0.20 // 25 down from the top
        firstNameTextField.frame.origin.x = (self.view.bounds.size.width - firstNameTextField.frame.size.width) / 2.0
        firstNameTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(firstNameTextField)
        
        lastNameTextField.tag = 90
        lastNameTextField.textAlignment = NSTextAlignment.Center
        lastNameTextField.borderActiveColor = UIColor(rgba: "#FFF")
        lastNameTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        lastNameTextField.backgroundColor = UIColor.clearColor()
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.placeholderColor = UIColor.grayColor()
        lastNameTextField.textColor = UIColor.grayColor()
        lastNameTextField.autocapitalizationType = UITextAutocapitalizationType.Words
        lastNameTextField.autocorrectionType = UITextAutocorrectionType.No
        lastNameTextField.keyboardType = UIKeyboardType.Default
        lastNameTextField.returnKeyType = UIReturnKeyType.Next
        lastNameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        lastNameTextField.frame.origin.y = screenHeight*0.30 // 25 down from the top
        lastNameTextField.frame.origin.x = (self.view.bounds.size.width - lastNameTextField.frame.size.width) / 2.0
        lastNameTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(lastNameTextField)

        dobTextField.tag = 91
        dobTextField.textAlignment = NSTextAlignment.Center
        dobTextField.borderActiveColor = UIColor(rgba: "#FFF")
        dobTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        dobTextField.backgroundColor = UIColor.clearColor()
        dobTextField.placeholder = "Date of Birth - MM/DD/YYYY"
        dobTextField.keyboardType = UIKeyboardType.NumberPad
        dobTextField.placeholderColor = UIColor.grayColor()
        dobTextField.textColor = UIColor.grayColor()
        dobTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        dobTextField.frame.origin.y = screenHeight*0.40 // 25 down from the top
        dobTextField.frame.origin.x = (self.view.bounds.size.width - dobTextField.frame.size.width) / 2.0
        view.addSubview(dobTextField)
        
        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    // Add send toolbar
    func addToolbarButton()
    {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let sendToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 50))
        // sendToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Continue", style: UIBarButtonItemStyle.Done, target: self, action: Selector("nextStep:"))
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)
        
        sendToolbar.items = items
        sendToolbar.sizeToFit()
        firstNameTextField.inputAccessoryView=sendToolbar
        lastNameTextField.inputAccessoryView=sendToolbar
        dobTextField.inputAccessoryView=sendToolbar
    }
    
    func nextStep(sender: AnyObject) {
        // Function for toolbar button
        var x = performValidation()
        if x == true {
            self.performSegueWithIdentifier("VC2", sender: sender)
        }
    }
    
    // Allow use of next and join on keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: Int = textField.tag + 1
        // print(nextTag)
        let nextResponder: UIResponder? = textField.superview?.superview?.viewWithTag(nextTag)
        if let nextR = nextResponder
        {
            // Found next responder, so set it.
            nextR.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    func displayErrorAlertMessage(alertMessage:String) {
        var alertView: SIAlertView = SIAlertView(title: "Error", andMessage: alertMessage)
        alertView.addButtonWithTitle("Ok", type: SIAlertViewButtonType.Default, handler: nil)
        alertView.transitionStyle = SIAlertViewTransitionStyle.DropDown
        alertView.show()
    }
    
    // Format dob number input textfield
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(textField == dobTextField) {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString : String = components.joinWithSeparator("")
            let length = decimalString.characters.count
            let decimalStr = decimalString as NSString
            
            if length == 0 || length > 8 || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 8) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if (length - index) > 2
            {
                dobMonth = decimalStr.substringWithRange(NSMakeRange(index, 2))
                formattedString.appendFormat("%@/", dobMonth)
//                print("dob month", dobMonth)
                index += 2
            }
            if length - index > 2
            {
                dobDay = decimalStr.substringWithRange(NSMakeRange(index, 2))
                formattedString.appendFormat("%@/", dobDay)
//                print("dob day", dobDay)
                index += 2
            }
            if length - index >= 4
            {
                dobYear = decimalStr.substringWithRange(NSMakeRange(index, 4))
//                print("dob year", dobYear)
            }
            
            let remainder = decimalStr.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
        }
        return true
        
    }
    
    func performValidation() -> Bool {
        if(firstNameTextField.text?.characters.count < 1) {
            displayErrorAlertMessage("First name cannot be empty")
            return false
        } else if(lastNameTextField.text?.characters.count < 1) {
            displayErrorAlertMessage("Last name cannot be empty")
            return false
        } else if(dobMonth == "" || dobDay == "" || dobYear == "") {
            displayErrorAlertMessage("Date of birth cannot be empty")
            return false
        } else if(Int(dobMonth) > 12 || Int(dobMonth) == 0 || Int(dobDay) == 0 || Int(dobDay) > 31 || Int(dobYear) > 2006 || Int(dobYear) < 1914) {
            displayErrorAlertMessage("Month cannot be greater than 12 or equal to zero. Day cannot be greater than 31 or equal to zero, year cannot be less than 1914 or greater than 2006")
            return false
        } else if(Int(dobMonth)! == 02 && Int(dobDay)! > 29 && (Int(dobYear)! % 4) == 0 ) {
            displayErrorAlertMessage("Leap years do not have more than 29 days")
            return false
        } else if(Int(dobMonth)! == 02 && Int(dobDay)! > 28 && (Int(dobYear)! % 4) != 0 ) {
            displayErrorAlertMessage("Invalid entry, not a leap year")
            return false
        } else if((Int(dobMonth) == 02 && Int(dobDay) > 30) || (Int(dobMonth) == 04 && Int(dobDay) > 30) || (Int(dobMonth) == 06 && Int(dobDay) > 30) || (Int(dobMonth) == 09 && Int(dobDay) > 30) || (Int(dobMonth) == 11 && Int(dobDay) > 30)) {
            displayErrorAlertMessage("The entered month does not have 31 days")
            return false
        } else {
            NSUserDefaults.standardUserDefaults().setValue(firstNameTextField.text!, forKey: "userFirstName")
            NSUserDefaults.standardUserDefaults().setValue(lastNameTextField.text!, forKey: "userLastName")
            NSUserDefaults.standardUserDefaults().setValue(dobDay, forKey: "userDobDay")
            NSUserDefaults.standardUserDefaults().setValue(dobMonth, forKey: "userDobMonth")
            NSUserDefaults.standardUserDefaults().setValue(dobYear, forKey: "userDobYear")
            NSUserDefaults.standardUserDefaults().synchronize();
        }
        return true
    }
    
    // VALIDATION
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if(identifier == "VC2") {
            if(firstNameTextField.text?.characters.count < 1) {
                displayErrorAlertMessage("First name cannot be empty")
                return false
            } else if(lastNameTextField.text?.characters.count < 1) {
                displayErrorAlertMessage("Last name cannot be empty")
                return false
            } else if(dobMonth == "" || dobDay == "" || dobYear == "") {
                displayErrorAlertMessage("Date of birth cannot be empty")
                return false
            } else if(Int(dobMonth) > 12 || Int(dobMonth) == 0 || Int(dobDay) == 0 || Int(dobDay) > 31 || Int(dobYear) > 2006 || Int(dobYear) < 1914) {
                displayErrorAlertMessage("Month cannot be greater than 12 or equal to zero. Day cannot be greater than 31 or equal to zero, year cannot be less than 1914 or greater than 2006")
                return false
            } else if(Int(dobMonth)! == 02 && Int(dobDay)! > 29 && (Int(dobYear)! % 4) == 0 ) {
                displayErrorAlertMessage("Leap years do not have more than 29 days")
                return false
            } else if(Int(dobMonth)! == 02 && Int(dobDay)! > 28 && (Int(dobYear)! % 4) != 0 ) {
                displayErrorAlertMessage("Invalid entry, not a leap year")
                return false
            } else if((Int(dobMonth) == 02 && Int(dobDay) > 30) || (Int(dobMonth) == 04 && Int(dobDay) > 30) || (Int(dobMonth) == 06 && Int(dobDay) > 30) || (Int(dobMonth) == 09 && Int(dobDay) > 30) || (Int(dobMonth) == 11 && Int(dobDay) > 30)) {
                displayErrorAlertMessage("The entered month does not have 31 days")
                return false
            } else {
                NSUserDefaults.standardUserDefaults().setValue(firstNameTextField.text!, forKey: "userFirstName")
                NSUserDefaults.standardUserDefaults().setValue(lastNameTextField.text!, forKey: "userLastName")
                NSUserDefaults.standardUserDefaults().setValue(dobDay, forKey: "userDobDay")
                NSUserDefaults.standardUserDefaults().setValue(dobMonth, forKey: "userDobMonth")
                NSUserDefaults.standardUserDefaults().setValue(dobYear, forKey: "userDobYear")
                NSUserDefaults.standardUserDefaults().synchronize();
            }
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}