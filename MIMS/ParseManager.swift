//
//  ParseManager.swift
//  MIMS
//
//  Created by Patrick Bush on 4/15/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import Foundation
import Parse


class PatientRecord: PFObject, PFSubclassing {
    
    var patient: Patient? {
        get {
            return self["patient"] as? Patient
        }
        set {
            self["patient"] = newValue
        }
    }
    
    var appointments: [Appointment]? {
        get {
            return self["appointments"] as? [Appointment]
        }
        set {
            self["appointments"] = newValue
        }
    }
    
    var treatments: [Treatment]? {
        get {
            return self["treatments"] as? [Treatment]
        }
        set {
            self["treatments"] = newValue
        }
    }
    
    var comments: [String]? {
        get {
            return self["comments"] as? [String]
        }
        set {
            self["comments"] = newValue
        }
    }
    
    //measurements
    
    //scans
    
    //tests
    class func parseClassName() -> String {
        return "Patient Record"
    }
}

class FinancialInformation: PFObject, PFSubclassing {
    
    var paymentInfo: String? {
        get {
            return self["paymentInfo"] as? String
        }
        set {
            self["paymentInfo"] = newValue
        }
    }
    
    var outstandingBalance: Int? {
        get {
            return self["outstandingBalance"] as? Int
        }
        set {
            self["outstandingBalance"] = newValue
        }
    }
    class func parseClassName() -> String {
        return "Financial Information"
    }
}

class Address: PFObject, PFSubclassing {
    
    var street: String? {
        get {
            return self["street"] as? String
        }
        set {
            self["street"] = newValue
        }
    }
    
    var city: String? {
        get {
            return self["city"] as? String
        }
        set {
            self["city"] = newValue
        }
    }
    
    var state: String? {
        get {
            return self["state"] as? String
        }
        set {
            self["state"] = newValue
        }
    }
    
    var zipCode: String? {
        get {
            return self["zip"] as? String
        }
        set {
            self["zip"] = newValue
        }
    }
    
    override var description: String {
       return "\(street)\n\(city), \(state) \(zipCode)"
    }
    
    class func parseClassName() -> String {
        return "Address"
    }
}

class InsuranceInfo: PFObject, PFSubclassing {
    
    var expirationDate: NSDate? {
        get {
            return self["expiryDate"] as? NSDate
        }
        set {
            self["expiryDate"] = newValue
        }
    }
    
    var memberID: String? {
        get {
            return self["id"] as? String
        }
        set {
            self["id"] = newValue
        }
    }
    
    var groupID: String? {
        get {
            return self["groupID"] as? String
        }
        set {
            self["groupID"] = newValue
        }
    }
    
    var copay: Int? {
        get {
            return self["copay"] as? Int
        }
        set {
            self["copay"] = newValue
        }
    }
    
    convenience init(initWith expiryDate: NSDate, memID: String, grpID: String, amount: Int) {
        self.init()
        self.expirationDate = expiryDate
        self.memberID = memID
        self.groupID = grpID
        self.copay = amount
    }
    
    
    class func parseClassName() ->String {
        return "Insurance Information"
    }
}


class Patient: PFObject, PFSubclassing {
    
    var name: String? {
        get {
            return self["name"] as? String
        }
        set {
            if newValue?.characters.count > 0 {
                self["name"] = newValue
            }
        }
    }
    
    var married: Bool? {
        get {
            return self["maritialStatus"] as? Bool
        }
        set {
            self["maritialStatus"] = newValue
        }
    }
    
    //Male is 1, female is 0
    var gender: Bool? {
        get {
            return self["gender"] as? Bool
        }
        set {
            self["gender"] = newValue
        }
    }
    
    var birthday: NSDate? {
        get {
            return self["birthday"] as? NSDate
        }
        set {
            self["birthday"] = newValue
        }
    }
    
    var ssn: String? {
        get {
            return self["ssn"] as? String
        }
        set {
            if newValue?.characters.count == 9 {
                self["ssn"] = newValue
            }
        }
    }
    
    var address: Address? {
        get {
            return self["address"] as? Address
        }
        set {
            self["address"] = newValue
        }
    }
    
    var insurance: InsuranceInfo? {
        get {
            return self["insuranceInfo"] as? InsuranceInfo
        }
        set {
            self["insuranceInfo"] = newValue
        }
    }
    
    var financials: FinancialInformation? {
        get {
            return self["financialData"] as? FinancialInformation
        }
        set {
            self["financialData"] = newValue
        }
    }
    

    
    class func parseClassName() -> String {
        return "Patient"
    }
    
}
class Department: PFObject, PFSubclassing {
    var departmentName: String? {
        get {
            return self["name"] as? String
        }
        
        set {
            self["name"] = newValue
        }
    }
    
    
    convenience init(withName name: String) {
        self.init()
        self.departmentName = name
    }
    
    class func parseClassName() -> String {
        return "Department"
    }
}

class Institution: PFObject, PFSubclassing {
    var institutionName: String? {
        get {
            return self["name"] as? String
        }
        set {
            self["name"] = newValue
        }
    }
    
    convenience init(initWithName name: String) {
        self.init()
        self.institutionName = name
    }
    
    class func parseClassName() -> String {
        return "Institution"
    }
}

class Treatment: PFObject, PFSubclassing {

//    dynamic var treatments: [Treatment]? {
//        get {
//            return self["treatments"] as? [Treatment]
//        }
//        set {
//            self["treatments"] = newValue
//        }
//    }
    
    var timeCreated: NSDate? {
        get {
            return self.createdAt
        }
    }
    
    class func parseClassName() -> String {
        return "Treatment"
    }
}

class Prescription: Treatment {
    
    var timeReceived: NSDate? {
        get {
            return self["timeReceived"] as? NSDate
        }
        set {
            self["timeReceived"] = newValue
        }
    }
    
    var timeFilled: NSDate? {
        get {
            return self["timeFilled"] as? NSDate
        }
        set {
            self["timeFilled"] = newValue
        }
    }
    
    var pharmacist: MIMSUser? {
        get {
            return self["pharmacist"] as? MIMSUser
        }
        set {
            self["pharmacist"] = newValue
        }
    }
}

class Surgery: Treatment {
    var attendingSurgeon: MIMSUser? {
        get {
            return self["attendingSurgeon"] as? MIMSUser
        }
        set {
            self["attendingSurgeon"] = newValue
        }
    }
}

class Immunization: Treatment {
    var immunizationTypes: String? {
        get {
            return self["immunizations"] as? String
        }
        set {
            self["immunizations"] = newValue
        }
    }
}

class Appointment: PFObject, PFSubclassing {
    
    
    
    class func parseClassName() -> String {
        return "Appointment"
    }
}

class MIMSUser: PFUser {
    
    dynamic var role = PFRole()
    dynamic var roleACL = PFACL()
    dynamic var department: Department? {
        get {
            return self["department"] as? Department
        }
        set {
            self["department"] = newValue
        }
    }
    dynamic var institution: Institution? {
        get {
            return self["institution"] as? Institution
        }
        set {
            self["institution"] = newValue
        }
    }
    dynamic var appointment: Appointment? {
        get {
            return self["appointment"] as? Appointment
        }
        set {
            self["appointment"] = newValue
        }
    }
    
    
//    override class func initialize() {
//        struct Static {
//            static var onceToken : dispatch_once_t = 0;
//        }
//        dispatch_once(&Static.onceToken) {
//            self.registerSubclass()
//        }
//        
//    }
    
//    override init() {
//    }
}


//Clerk or receptionist
class AdminUser: MIMSUser {
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
        
    }
  
    override init() {
        super.init()
        roleACL.publicReadAccess = true
        roleACL.publicWriteAccess = true
        role = PFRole(name: "Admin", acl: roleACL)
        role.users.addObject(self)
        role.saveInBackground()
    }
}

//Lab Technician
class TechnicalUser: MIMSUser {
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
        
    }

    override init() {
        super.init()
        roleACL.publicReadAccess = false
        roleACL.publicReadAccess = false
        role = PFRole(name: "Technical", acl: roleACL)
        role.users.addObject(self)
        role.saveInBackground()
    }
}

//Doctors, Nurses
class OperationalUser: MIMSUser {
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
        
    }
    
    override init() {
        super.init()
        roleACL.publicReadAccess = false
        role = PFRole(name: "Operational", acl: roleACL)
        role.users.addObject(self)
        role.saveInBackground()

    }
}


enum ParseErrorCodes: ErrorType {
    case InvalidUsernameLength(message: String)
    case InvalidPasswordLength(message: String)
    case InvalidKey(message: String)
}


class ParseClient {

    class func login(username: String, password: String, completion: (user: MIMSUser?, error: NSError?) ->()) throws {
        guard username.characters.count >= 6 else {
            throw ParseErrorCodes.InvalidUsernameLength(message: "You didn't enter enough characters for your username")
        }
        
        guard password.characters.count >= 8 else {
            throw ParseErrorCodes.InvalidPasswordLength(message: "You didn't enter enough characters for your password")
        }

        MIMSUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
            if error == nil && user != nil {
                completion(user: user! as? MIMSUser, error: nil)
            } else {
                completion(user: nil, error: error!)
            }
        }
    }
    
    class func logout(user: PFUser, completion: (success: Bool?, error: NSError?) ->()) {
        guard MIMSUser.currentUser() != nil else {
            return
        }
        MIMSUser.logOutInBackgroundWithBlock { (error) in
            if error == nil {
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error!)
            }
        }
    }
    
    class func queryUsers(key: String, value: AnyObject, completion: (users: [MIMSUser]?, error: NSError?) ->()) throws {
        guard key.characters.count > 0 else {
            throw ParseErrorCodes.InvalidKey(message: "An invalid key was sent")
        }
        let query = MIMSUser.query()
        query?.whereKey(key, equalTo: value)
        query?.findObjectsInBackgroundWithBlock({ (objects, error) in
            if objects != nil && error == nil {
                completion(users: objects! as? [MIMSUser], error: nil)
            }
        })
    }
    
    class func queryPatients(key: String, value: AnyObject, completion: (patients: [PatientRecord]?, error: NSError?) ->()) {
        //let query = PFQuery(className: <#T##String#>)
    }
}