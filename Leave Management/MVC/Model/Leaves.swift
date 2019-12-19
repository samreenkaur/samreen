//
//  Leaves.swift
//  Leave Management
//
//  Created by osx on 19/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import Foundation
import RealmSwift

class LeavesModel: Object {
    
    //MARK:- Variables
    @objc dynamic var id : String = ""
    @objc dynamic var fullName: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var profilePic: String = ""
    @objc dynamic var designation: String = ""
    @objc dynamic var refreshToken: String = ""
    @objc dynamic var tokenType: String = ""
    @objc dynamic var accessToken: String = ""
    @objc dynamic var userData = "userData"
    
    
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
        if let item = dict["userId"] as? String
        {
            self.id = item
        }
        if let item = dict["fullName"] as? String
        {
            self.fullName = item
        }
        if let item = dict["Email"] as? String
        {
            self.email = item
        }
        if let item = dict["ProfilePictureUrl"] as? String
        {
            self.profilePic = item
        }
        if let item = dict["designation"] as? String
        {
            self.designation = item
        }
        if let item = dict["PhoneNumber"] as? String
        {
            self.phoneNumber = item
        }
        if let item = dict["refresh_token"] as? String
        {
            self.refreshToken = item
        }
        if let item = dict["access_token"] as? String
        {
            self.accessToken = item
        }
        if let item = dict["token_type"] as? String
        {
            self.tokenType = item
        }
    }
}
