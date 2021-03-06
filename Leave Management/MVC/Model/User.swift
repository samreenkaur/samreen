//
//  User.swift
//  Leave Management
//
//  Created by osx on 09/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import Foundation
import RealmSwift

class UserModel: Object {
    
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
        return "userData"
    }
    override static func ignoredProperties() -> [String] {
        return []
    }
    convenience init(dict : [String:AnyObject])
    {
        self.init()
        if let item = dict["Id"] as? String
        {
            self.id = item
        }
        if let item = dict["Id"] as? Int
        {
            self.id = "\(item)"
        }
        if let item = dict["FullName"] as? String
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
        if let item = dict["Designation"] as? String
        {
            self.designation = item
        }
        if let item = dict["Phone"] as? String
        {
            self.phoneNumber = item
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
    
    func getUserloggedIn() -> UserModel?
    {
        do {
            let realm = try Realm()
            let result = realm.object(ofType: UserModel.self, forPrimaryKey: "userData")
            if let userdata = result{
                return userdata
            }
        } catch let error as NSError {
            print(error)
            return nil
        }
        
        return nil
    }
    
}

//struct User: Codable, CustomStringConvertible {
//    public let ID: String
//    public let fullname: String
//    public let email: String
//    public let phoneNumber: String
//    public let designation: String
//    public let profilePic: String
//
//    enum CodingKeys: String, CodingKey {
//        case ID = "id"
//        case fullname = "name"
//        case email = "email"
//        case phoneNumber
//        case designation
//        case profilePic = "profile_pic"
//    }
//
//    public var description: String {
//        return "Authenticated User(id: \(self.ID), name: \(self.fullname), email: \(self.email), designation: \(self.designation), profilePic: \(self.profilePic), phoneNumber: \(self.phoneNumber)"
//    }
//}


