//
//  Customer.swift
//  customerList
//
//  Created by Rohit Rajput on 28/04/18.
//  Copyright © 2018 Rohit Rajput. All rights reserved.
//

import Foundation

// MARK: - Data Model

class Customer {
    
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var number: String?
    
    init(firstName: String, lastName: String, email: String, phone: String, number: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.number = number
    }
}
