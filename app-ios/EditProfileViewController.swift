//
//  EditProfileViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/18/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Former
import JSSAlertView

final class EditProfileViewController: FormViewController, UINavigationBarDelegate {
    
    var dic: Dictionary<String, AnyObject> = [:]
    
    var detailUser: User? {
        didSet {
            // config
        }
    }
    
    // MARK: Public
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        super.viewDidLoad()
        User.getProfile { (user, err) in
            self.configure(user!)
        }
    }
    
    // MARK: Private
    
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    
    private lazy var informationSection: SectionFormer = {
        let ssnRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "SSN Last 4"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = "For transfer volumes of $20,000+"
                $0.text = Profile.sharedInstance.ssn
            }.onTextChanged {
                self.dic["legal_entity_ssn_last_4"] = $0
                Profile.sharedInstance.ssn = $0
        }
        let businessName = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Business Name"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.businessName
            }.onTextChanged {
                self.dic["legal_entity_business_name"] = $0
                Profile.sharedInstance.businessName = $0
        }
        let businessAddressRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Address"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.businessAddressLine1
            }.onTextChanged {

                Profile.sharedInstance.businessAddressLine1 = $0
        }
        let businessAddressCountryRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Country"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.businessAddressCountry
            }.onTextChanged {
                self.dic["legal_entity_address_country"] = $0
                Profile.sharedInstance.businessAddressCountry = $0
        }
        let businessAddressZipRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "ZIP"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.businessAddressZip
            }.onTextChanged {
                self.dic["legal_entity_address_postal_code"] = $0
                Profile.sharedInstance.businessAddressZip = $0
        }
        let businessAddressCityRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "City"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = ""
                $0.text = Profile.sharedInstance.businessAddressCity
            }.onTextChanged {
                self.dic["legal_entity_address_city"] = $0
                Profile.sharedInstance.businessAddressCity = $0
        }
        let businessAddressStateRow = InlinePickerRowFormer<CustomLabelCell, String>(instantiateType: .Nib(nibName: "CustomLabelCell")) {
            $0.titleLabel.text = "State"
            }.inlineCellSetup {
                    $0.tintColor = UIColor.darkGrayColor()
            }.configure {
                $0.rowHeight = 60
                let businessStates = Profile.sharedInstance.state
                $0.pickerItems = businessStates.map {
                    InlinePickerItem(title: $0)
                }
                if let businessState = Profile.sharedInstance.businessAddressState {
                    $0.selectedRow = businessStates.indexOf(businessState) ?? 0
                }
            }.onValueChanged {
                self.dic["legal_entity_address_state"] = $0.title
                Profile.sharedInstance.businessAddressState = $0.title
        }
        let businessTypeRow = InlinePickerRowFormer<CustomLabelCell, String>(instantiateType: .Nib(nibName: "CustomLabelCell")) {
            $0.titleLabel.text = "Type"
            }.inlineCellSetup {
                    $0.tintColor = UIColor.darkGrayColor()
            }.configure {
                $0.rowHeight = 60
                let businessTypes = ["individual", "company"]
                $0.pickerItems = businessTypes.map {
                    InlinePickerItem(title: $0)
                }
                if let businessType = Profile.sharedInstance.businessType {
                    $0.selectedRow = businessTypes.indexOf(businessType) ?? 0
                }
            }.onValueChanged {
                self.dic["legal_entity_type"] = $0.title
                Profile.sharedInstance.businessType = $0.title
        }
        
        return SectionFormer(rowFormer: businessName, businessAddressRow, businessAddressCountryRow, businessAddressZipRow, businessAddressCityRow, businessAddressStateRow, businessTypeRow, ssnRow)
    }()
    
    func save(sender: AnyObject) {
        // print(dic)
        User.saveProfile(dic) { (user, bool, err) in
            if bool == true {
                self.showSuccessAlert("Profile Saved")
            } else {
                self.showErrorAlert((err?.localizedDescription)!)
            }
        }
    }
    
    private func configure(user: User) {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height-3)
        tableView.contentInset.top = 80
        tableView.contentInset.bottom = 60
        tableView.contentOffset.y = 0
        tableView.backgroundColor = UIColor(rgba: "#efeff4")
        tableView.showsVerticalScrollIndicator = false
        
        title = "Edit Profile"
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 60)
        self.navigationController?.navigationBar.backgroundColor = UIColor.slateBlue()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditProfileViewController.save(_:)))
        
        self.navigationItem.rightBarButtonItem = saveButton
        
//        Account.getStripeAccount { (acct, err) in
//            print(acct)
//        }
        
        // Create RowFomers
        
        let firstNameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "First Name"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = user.first_name
                $0.text = Profile.sharedInstance.firstName
            }.onTextChanged {
                self.dic["first_name"] = $0
                Profile.sharedInstance.firstName = $0
        }
        let lastNameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Last Name"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = user.last_name
                $0.text = Profile.sharedInstance.lastName
            }.onTextChanged {
                self.dic["last_name"] = $0
                Profile.sharedInstance.lastName = $0
        }
        let usernameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Username"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            $0.textField.autocapitalizationType = UITextAutocapitalizationType.None
            $0.textField.autocorrectionType = UITextAutocorrectionType.No
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = user.username
                $0.text = Profile.sharedInstance.username
            }.onTextChanged {
                self.dic["username"] = $0
                Profile.sharedInstance.username = $0
        }
        let emailRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Email"
            $0.textField.keyboardType = .EmailAddress
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = user.email
                $0.text = Profile.sharedInstance.email
            }.onTextChanged {
                self.dic["email"] = $0
                Profile.sharedInstance.email = $0
        }
        let phoneRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Phone"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = user.phone
                $0.text = Profile.sharedInstance.phoneNumber
            }.onTextChanged {
                self.dic["phone_number"] = $0
                Profile.sharedInstance.phoneNumber = $0
        }
        let birthdayRow = InlineDatePickerRowFormer<CustomLabelCell>(instantiateType: .Nib(nibName: "CustomLabelCell")) {
            $0.titleLabel.text = "Birthday"
            }.configure {
                $0.date = Profile.sharedInstance.birthDay ?? NSDate()
                $0.rowHeight = 60
            }.inlineCellSetup {
                $0.tintColor = UIColor.darkGrayColor()
                $0.datePicker.datePickerMode = .Date
            }.onDateChanged {
                self.dic["birthday"] = String($0.timeIntervalSince1970)
                Profile.sharedInstance.birthDay = $0
        }
        let bioRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
//            $0.textView.textColor = .formerSubColor()
            $0.textView.font = UIFont(name: "Avenir-Light", size: 14)
            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.rowHeight = 60
                $0.placeholder = "Add your individual or company bio"
                $0.text = Profile.sharedInstance.introduction
            }.onTextChanged {
                self.dic["bio"] = $0
                Profile.sharedInstance.introduction = $0
        }
        let moreRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Enable higher limit transfer volumes?"
            $0.titleLabel.textColor = UIColor.darkGrayColor()
            $0.titleLabel.font = UIFont(name: "Avenir-Light", size: 14)
//            $0.switchButton.onTintColor = .formerSubColor()
            }.configure {
                $0.rowHeight = 60
                $0.switched = Profile.sharedInstance.moreInformation
                $0.switchWhenSelected = true
            }.onSwitchChanged { [weak self] in
                Profile.sharedInstance.moreInformation = $0
                self?.switchInfomationSection()
        }
    
        // Create Headers
        
        let createHeader: (String -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 40
                    $0.text = text
            }
        }
        
        // Create SectionFormers
        
        // Temporarily remove image section
        //let imageSection = SectionFormer(rowFormer: imageRow)
        //    .set(headerViewFormer: createHeader("Profile Image"))
        let aboutSection = SectionFormer(rowFormer: firstNameRow, lastNameRow, usernameRow, emailRow, birthdayRow, phoneRow)
            .set(headerViewFormer: createHeader("Profile information"))
        let moreSection = SectionFormer(rowFormer: moreRow)
            .set(headerViewFormer: createHeader("Additional transfer-enabling security infomation"))
        
        former.append(sectionFormer: aboutSection, moreSection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
        if Profile.sharedInstance.moreInformation {
            former.append(sectionFormer: informationSection)
        }
    }

    private func switchInfomationSection() {
        if Profile.sharedInstance.moreInformation {
            former.insertUpdate(sectionFormer: informationSection, toSection: former.numberOfSections, rowAnimation: .Top)
        } else {
            former.removeUpdate(sectionFormer: informationSection, rowAnimation: .Top)
        }
    }
    
    private func showSuccessAlert(msg: String) {
        let customIcon:UIImage = UIImage(named: "ic_check_light")! // your custom icon UIImage
        let customColor:UIColor = UIColor.mediumBlue() // base color for the alert
        self.view.endEditing(true)
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: msg,
            buttonText: "Ok",
            noButtons: false,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }
    
    private func showErrorAlert(msg: String) {
        let customIcon:UIImage = UIImage(named: "ic_close_light")! // your custom icon UIImage
        let customColor:UIColor = UIColor.brandRed() // base color for the alert
        self.view.endEditing(true)
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: msg,
            buttonText: "Ok",
            noButtons: false,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }
    
}