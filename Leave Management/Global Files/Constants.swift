//
//  Constants.swift
//  Leave Management
//
//  Created by osx on 04/12/19.
//  Copyright © 2019 osx. All rights reserved.
//
import UIKit

//MARK:- URL
struct APIUrl{
    
    static let base = "http://35.154.186.154:3031"
    static let readMe = ""

    static let signUp = "/api/Account/Register"
    static let token = "/token"
    static let resetPassword = "/api/Account/ResetPassword"
    static let forgotPassword = "/api/Account/ForgotPassword"
    static let editProfile = "/api/User/Update"
    
    static let getAllLeaves = "/api/Leave/GetAll"

}

//MARK:- View Controllers
var kLoginViewController = "LoginViewController"
var kSignUpViewController = "SignUpViewController"
var kForgotPasswordViewController = "ForgotPasswordViewController"

var kHomeViewController = "HomeViewController"
var kNotificationsViewController = "NotificationsViewController"

var kApplyLeaveViewController = "ApplyLeaveViewController"
var kHolidaysViewController = "HolidaysViewController"
var kLeaveStatusViewController = "LeaveStatusViewController"
var kLeaveStatusTableViewController = "LeaveStatusTableViewController"
var kCancelReasonViewController = "CancelReasonViewController"
var kMyProfileViewController = "MyProfileViewController"

var kEditProfileViewController = "EditProfileViewController"
var kChangePasswordViewController = "ChangePasswordViewController"
var kResetPasswordViewController = "ResetPasswordViewController"

//MARK:- Cell Identifiers
var kNotificationTableViewCell = "NotificationTableViewCell"
var kHolidaysTableViewCell = "HolidaysTableViewCell"
var kLeaveStatusTableViewCell = "LeaveStatusTableViewCell"


//MARK:- Colors
struct Colors{

    static let themeColor = #colorLiteral(red: 0, green: 0.5674916506, blue: 0.6506296396, alpha: 1)
    static let themeGreen = #colorLiteral(red: 0, green: 0.8230088353, blue: 0.3611240387, alpha: 1)
    static let themeRed = #colorLiteral(red: 0.9728515744, green: 0.2362010479, blue: 0.2031595707, alpha: 1)
    static let themeYellow = #colorLiteral(red: 0.8978995681, green: 0.7817478776, blue: 0, alpha: 1)
    static let themeShadow = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    static let themeLink = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    static let themeLightGray = #colorLiteral(red: 0.6669999957, green: 0.6669999957, blue: 0.6669999957, alpha: 1)
    static let themeDarkGray = #colorLiteral(red: 0.3330000043, green: 0.3330000043, blue: 0.3330000043, alpha: 1)
    static let themeTransparentBackground = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    
}

//MARK:- Icons
struct Images{
    static let eyeHidden = UIImage(named: "eye")
    static let eyeShown = UIImage(named: "visibility")
    static let userPlaceholder = UIImage(named: "user")

}

//MARK:- Basic Authentication
let loginString = String(format: "%@:%@", "email", "password")
let loginData = loginString.data(using: String.Encoding.utf8)!
let basicAuthString = "Basic \(loginData.base64EncodedString())"


//MARK:- Formatter
let dateFormatter = DateFormatter()

//MARK:- Enumerations
enum Month: Int {
   case January = 1, February, March, April, May, June, July, August,
      September, October, November, December
}

