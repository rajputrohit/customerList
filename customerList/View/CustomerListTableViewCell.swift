//
//  CustomerListTableViewCell.swift
//  customerList
//
//  Created by Rohit Rajput on 28/04/18.
//  Copyright © 2018 Rohit Rajput. All rights reserved.
//

import UIKit

class CustomerListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailIDLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Mark: - Setup Cell
    func configureCell(person: Customer) {
        
        if !person.firstName.isEmpty {
            nameLabel.text = "Name - \(person.firstName)"
        } else if !person.lastName.isEmpty {
            nameLabel.text = "Name - \(person.lastName)"
        } else {
            nameLabel.text = "Name - \(setupNameString(string: person.email))"
        }
        
        emailIDLabel.text = "Email ID - \(person.email)"
        phoneLabel.text = "Phone - \(person.phone)"
    }
    
    // Mark: - Setup String from Email ID
    func setupNameString(string: String) -> String {
        if let range = string.range(of: "@") {
            let firstPart = string[string.startIndex..<range.lowerBound]
            let str = String(firstPart)
            let stringWithoutDigit = (str.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
            let finalString = stringWithoutDigit.replacingOccurrences(of: ".", with: " ")
            
            return finalString
        }
        return string
    }
    
}

