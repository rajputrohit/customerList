//
//  Constants.swift
//  customerList
//
//  Created by Rohit Rajput on 28/04/18.
//  Copyright © 2018 Rohit Rajput. All rights reserved.
//

import Foundation

typealias COMPLETION_HANDLER = (_ success: Bool) -> Void

// Mark: - Notification.name
let NOTIFY_USER_DATA_DID_CHANGE = Notification.Name(rawValue: "notifyUserDataDidChange")
let NOTIFY_ADDED_DATA = Notification.Name(rawValue: "notifyAddedData")

// Mark: - Headers
let HEADER = [
    "content-type" : "application/json",
    "accept" : "application/json"
]

let checkInURL = "https://api.birdeye.com/resources/v1/customer/checkin?bid=151722397793976&api_key=vrbXq3jAflrtwDaUMcTmjf9TS135QAyd"
let getCustomerURL = "https://api.birdeye.com/resources/v1/customer/all?businessId=151722397793976&api_key=vrbXq3jAflrtwDaUMcTmjf9TS135QAyd"

