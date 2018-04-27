//
//  CheckInViewController.swift
//  customerList
//
//  Created by Rohit Rajput on 28/04/18.
//  Copyright © 2018 Rohit Rajput. All rights reserved.
//

import UIKit

class CheckInViewController: UIViewController {
    
    // Mark: - Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addCustomerButtonDidPress(_ sender: Any) {
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let emailID = emailIDTextField.text, let phone = phoneTextField.text   else {
            return
        }
        
        // Mark: - Call Check In URL to Add Customer
        BirdeyeService.instance.checkInCustomer(firstName: firstName, lastName: lastName, emailID: emailID, phone: phone) { (success) in
            if success {
                NotificationCenter.default.post(name: NOTIFY_USER_DATA_DID_CHANGE, object: nil)
            }
        }
        navigationController?.popViewController(animated: true)
    }

}








