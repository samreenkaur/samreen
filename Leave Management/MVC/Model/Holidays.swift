//
//  Holidays.swift
//  Leave Management
//
//  Created by osx on 09/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import Foundation
import RealmSwift

class HolidaysModel: Object {
    
    //MARK:- Variables
    @objc dynamic var id = Int()
    @objc dynamic var title: String = ""
    @objc dynamic var date: String = ""
    
    
    //MARK:- Main func
    override static func primaryKey() -> String? {
        return "id"
    }
    override static func ignoredProperties() -> [String] {
        return []
    }
    convenience init(dict : [String:AnyObject])
    {
        self.init()
        if let item = dict["id"] as? Int
        {
            self.id = item
        }
        if let item = dict["title"] as? String
        {
            self.title = item
        }
        if let item = dict["date"] as? String
        {
            self.date = item
        }
        
    }
    
}
