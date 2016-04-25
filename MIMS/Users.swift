//
//  Users.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/25/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import Foundation
import Parse

enum UserTypes: String {
    case AdminUser = "Admin"
    case TechnicalUser = "Technical"
    case OperationalUser = "Operational"
}

enum UserErrors: ErrorType {
    case InvalidUserType
}

class MIMSUser: PFUser {
    
    dynamic var userType: String? {
        get {
            return self["userType"] as? String
        }
        set { if newValue != nil { self["userType"] = newValue! } }
    }
    
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
    
    convenience init(withUserType type: String, department: String, institution: String) throws {
        self.init()
        guard let userType = UserTypes(rawValue: type) else {
            throw UserErrors.InvalidUserType
        }
        self.userType = userType.rawValue
        ParseClient.queryDepartments("name", value: department) { (departments, error) in
            if error == nil && departments != nil {
                self.department = try! Department(withName: department)
            } else {
                self.department = departments
            }
        }
        ParseClient.queryInstitutions("name", value: institution) { (institutions, error) in
            if error == nil && institutions != nil {
                self.institution = Institution(initWithName: institution)
            } else {
                self.institution = institutions
            }
        }
        
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
        
    }
    
}

