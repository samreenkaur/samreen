//
//  Constants.swift
//  Leave Management
//
//  Created by osx on 04/12/19.
//  Copyright © 2019 osx. All rights reserved.
//
import UIKit

//MARK:- URL
let baseUrl = ""
let readMeUrl = ""

let loginUrl = "\(baseUrl)"
let signUpUrl = "\(baseUrl)"


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
let themeColor = #colorLiteral(red: 0, green: 0.5674916506, blue: 0.6506296396, alpha: 1)
let themeColorGreen = #colorLiteral(red: 0, green: 0.8230088353, blue: 0.3611240387, alpha: 1)
let themeColorRed = #colorLiteral(red: 0.9728515744, green: 0.2362010479, blue: 0.2031595707, alpha: 1)
let themeColorYellow = #colorLiteral(red: 0.8978995681, green: 0.7817478776, blue: 0, alpha: 1)
let themeColorShadow = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
let themeColorLink = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
let themeColorLightGray = #colorLiteral(red: 0.6669999957, green: 0.6669999957, blue: 0.6669999957, alpha: 1)
let themeColorDarkGray = #colorLiteral(red: 0.3330000043, green: 0.3330000043, blue: 0.3330000043, alpha: 1)


//MARK:- Icons
let eyeHidden = UIImage(named: "eye")
let eyeShown = UIImage(named: "visibility")
let userPlaceholder = UIImage(named: "user")


//MARK:- Basic Authentication
let loginString = String(format: "%@:%@", "email", "password")
let loginData = loginString.data(using: String.Encoding.utf8)!
let basicAuthString = "Basic \(loginData.base64EncodedString())"
