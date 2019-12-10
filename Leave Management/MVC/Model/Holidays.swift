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
    @objc dynamic var completeDate: String = ""
    @objc dynamic var day = Int()
    @objc dynamic var month = Int()
    @objc dynamic var year = Int()
    
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
            self.completeDate = item
            if item != ""{
                let date = self.convertStringToDate(dateString: item) ?? Date()
                let component = Calendar.current.dateComponents([.day,.month,.year], from: date)
                self.day = component.day ?? 0
                self.month = component.month ?? 0
                self.year = component.year ?? 0
            }
        }
    }
    
    func convertStringToDate(dateString : String) -> Date?{
        let formatter = dateFormatter
        formatter.dateFormat = "dd MM yyyy"
        let date = formatter.date(from: dateString)
        return date
    }
    
}
