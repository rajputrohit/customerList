//
//  BirdeyeService.swift
//  customerList
//
//  Created by Rohit Rajput on 28/04/18.
//  Copyright © 2018 Rohit Rajput. All rights reserved.
//

import Foundation
import SwiftyJSON

class BirdeyeService {
    
    // MARK: - Singleton
    static let instance = BirdeyeService()
    
    var customer = [Customer]()
    
    // Mark: - Call
    func getCustomer(completion: @escaping COMPLETION_HANDLER) {
        let url = URL(string: getCustomerURL)
        let urlRequest = NSMutableURLRequest(url: url!)
        
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = HEADER
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            if let data = data {
                do {
                    // Mark: - JSON Serialization
                    if let json = try? JSON(data: data) {
                        for item in json.array! {
                            let firstName = item["firstName"].stringValue
                            let lastName = item["lastName"].stringValue
                            let email = item["emailId"].stringValue
                            let phone = item["phone"].stringValue
                            let number = item["number"].stringValue
                            
                            let person = Customer(firstName: firstName, lastName: lastName, email: email, phone: phone, number: number)
                            self.customer.append(person)
                        }
                        completion(true)
                    }
                }
            }
        }
        task.resume()
    }
    
    func checkInCustomer(firstName: String, lastName: String, emailID: String, phone: String, completion: @escaping COMPLETION_HANDLER) {
        let url = URL(string: checkInURL)
        let urlRequest = NSMutableURLRequest(url: url!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = HEADER
        
        let body = [
            "name" : "\(firstName) \(lastName)",
            "emailId" : emailID,
            "phone" : phone,
            ]
        
        // Mark: - Converting body into Data format
        let postBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        urlRequest.httpBody = postBody
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            if error == nil {
                let person = Customer(firstName: firstName, lastName: lastName, email: emailID, phone: phone, number: " ")
                self.customer.append(person)
                
                NotificationCenter.default.post(name: NOTIFY_ADDED_DATA, object: nil)
                completion(true)
            } else {
                print(error!.localizedDescription)
            }
        }
        task.resume()
    }
    
    func deletePerson(number: String, completion: @escaping COMPLETION_HANDLER) {
        let url = URL(string: "https://api.birdeye.com/resources/v1/customer/id/\(number)?api_key=vrbXq3jAflrtwDaUMcTmjf9TS135QAyd")
        let urlRequest = NSMutableURLRequest(url: url!)
        
        urlRequest.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            if  error == nil {
                completion(true)
            } else {
                print(error!.localizedDescription)
            }
        }
        task.resume()
    }
    
}
