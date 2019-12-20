//
//  ResponseModel.swift
//  Leave Management
//
//  Created by osx on 20/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import Foundation

struct ResponseModel{
    
    var sessionExpired: Bool = false
    var success = Int()
    var errorMessage = ""
    var data = [String: AnyObject]()
    var dataArray = [[String: AnyObject]]()
    private var message = ""
    private var error = ""
    private var errorDescription = ""
    
    
    init(_ dict : [String:AnyObject])
    {
//        super.init()
        
        if let item = dict["Success"] as? Int
        {
            self.success = item
        }
        if let item = dict["error"] as? String
        {
            self.error = item
        }
        if let item = dict["error_description"] as? String
        {
            self.errorDescription = item
        }
        if let item = dict["Message"] as? String
        {
            self.message = item
            if message == "Authorization has been denied for this request."{
                self.sessionExpired = true
            }
        }
        if let item = dict["Data"] as? [String: AnyObject]
        {
            self.data = item
        }
        if let item = dict["Data"] as? [[String: AnyObject]]
        {
            self.dataArray = item
        }
        if self.success == 0{
            if !self.message.isEmpty
            {
                errorMessage = self.message
            }
            else if !self.errorDescription.isEmpty
            {
                errorMessage = self.errorDescription
            }
        }
        
        
    }
    
}

