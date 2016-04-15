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
            self["name"] = newValue
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
            self["ssn"] = newValue
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
    
    
//    init(withName name: String) {
//        super.init()
//        self.departmentName = name
//    }
    
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
    

    
    class func parseClassName() -> String {
        return "Institution"
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
    //dynamic var
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
        
    }
    
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


class ParseClient {
    class func login(username: String, password: String, completion: (user: MIMSUser?, error: NSError?) ->()) {
        MIMSUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
            if error == nil && user != nil {
                completion(user: user! as? MIMSUser, error: nil)
            } else {
                completion(user: nil, error: error!)
            }
        }
    }
    
    class func logout(user: PFUser, completion: (success: Bool?, error: NSError?) ->()) {
        MIMSUser.logOutInBackgroundWithBlock { (error) in
            if error == nil {
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error!)
            }
        }
    }
    
    class func queryUsers(key: String, value: AnyObject, completion: (users: [PFObject]?, error: NSError?) ->()) {
        let query = MIMSUser.query()
        query?.whereKey(key, equalTo: value)
        query?.findObjectsInBackgroundWithBlock({ (objects, error) in
            if objects != nil && error == nil {
                completion(users: objects!, error: nil)
            }
        })
    }
    
    class func queryPatients(key: String, value: AnyObject, completion: (patients: [PFObject]?, error: NSError?) ->()) {
        //let query = PFQuery(className: <#T##String#>)
    }
}