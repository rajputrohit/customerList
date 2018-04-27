//
//  SQLiteDatabase.swift
//  customerList
//
//  Created by Rohit Rajput on 28/04/18.
//  Copyright © 2018 Rohit Rajput. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteDatabase {
    
    var customer = [Customer]()
    
    init(_ customer: [Customer]) {
        self.customer = customer
    }
    
    // Mark: - Create Table SQL Query
    let createTableString = """
CREATE TABLE Person(
Id INT PRIMARY KEY NOT NULL,
FirstName CHAR(255),
LastName CHAR(255),
EmailID CHAR(255),
Phone CHAR(255),
Number CHAR(255)
);
"""
    
    // Mark: - Insert Data SQL Query
    let insertStatementString = "INSERT INTO Person (Id, FirstName, LastName, EmailID, Phone, Number) VALUES (?, ?, ?, ?, ?, ?);"
    
    // Mark: - Read Table SQL query
    let queryStatementString = "SELECT * FROM Person;"
    
    func executeQuery() {
        var db: OpaquePointer?
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BirdeyeCustomer.sqlite")
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Successfully opened connection at \(fileURL.path)")
        }
        
        // Mark: - Check if this is the first launch
        if UserDefaults.standard.bool(forKey: "HasLaunchedBefore") {
            print("App has launched before")
            insertDataIntoTable(db: db!)
            readDataFromTable(db: db!)
        } else {
            print("This is the first launch ever")
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
            UserDefaults.standard.synchronize()
            
            createTable(db: db!)
            insertDataIntoTable(db: db!)
            readDataFromTable(db: db!)
        }
    }
    
    // Mark: - Create Table function
    func createTable(db: OpaquePointer) {
        var createTableStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Contact table created.")
            } else {
                print("Contact table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    // Mark: - Insert Data into Table function
    func insertDataIntoTable(db: OpaquePointer) {
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            for (index, person) in customer.enumerated() {
                let id = Int32(index + 1)
                
                sqlite3_bind_int(insertStatement, 1, id)
                sqlite3_bind_text(insertStatement, 2, NSString(string: person.firstName).utf8String , -1, nil)
                sqlite3_bind_text(insertStatement, 3, NSString(string: person.lastName).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, NSString(string: person.email).utf8String , -1, nil)
                sqlite3_bind_text(insertStatement, 5, NSString(string: person.phone).utf8String , -1, nil)
                sqlite3_bind_text(insertStatement, 6, NSString(string: person.number!).utf8String , -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
                sqlite3_reset(insertStatement)
            }
            sqlite3_finalize(insertStatement)
        } else {
            print("INSERT statement could not be prepared.")
        }
    }
    
    
    // Mark: - Read Data from Table function
    func readDataFromTable(db: OpaquePointer) {
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {                
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let firstName = String(cString: queryResultCol1!)
                
                let queryResultCol2 = sqlite3_column_text(queryStatement, 2)
                let lastName = String(cString: queryResultCol2!)
                
                let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
                let email = String(cString: queryResultCol3!)
                
                let queryResultCol4 = sqlite3_column_text(queryStatement, 4)
                let phone = String(cString: queryResultCol4!)
                
                let queryResultCol5 = sqlite3_column_text(queryStatement, 5)
                let number = String(cString: queryResultCol5!)
                
                let person = Customer(firstName: firstName, lastName: lastName, email: email, phone: phone, number: number)
                self.customer.append(person)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
    }
    
}








