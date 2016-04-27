//
//  Helpers.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/25/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import Foundation
import Parse

enum AddressError: ErrorType {
    case InvalidStreet
    case InvalidCity
    case InvalidState
    case InvalidZip
    case InvalidAddress
}
//MARK: Address Class
/**
 *  Address class with the patient's address
 *  private street: String -- the street name and number
 *  private city: String -- the city
 *  private state: String -- the state
 *  private zipCode: String -- the zip code
 *  description: String -- the description of the address
 *  Parse Class Name: "Address"
 */
class Address: PFObject, PFSubclassing {
    
    private var street: String? {
        get {
            return self["street"] as? String
        }
        set {
            self["street"] = newValue!
        }
    }
    
    private var city: String? {
        get {
            return self["city"] as? String
        }
        set {
            self["city"] = newValue!
        }
    }
    
    private var state: String? {
        get {
            return self["state"] as? String
        }
        set {
            self["state"] = newValue!
        }
    }
    
    private var zipCode: String? {
        get {
            return self["zip"] as? String
        }
        set {
            self["zip"] = newValue!
        }
    }
    
    override var description: String {
        return "\(street!)\n\(city!), \(state!) \(zipCode!)"
    }
    
    /**
     Add a complete new address for the patient
     
     - parameter street: the new street name and number
     - parameter city:   the new city name
     - parameter state:  the new state name
     - parameter zip:    the new zip
     
     - throws:   An error if there is invalid input
     */
    func newAddress(street: String, city: String, state: String, zip: String) throws {
        guard street != "" && city != "" && state != "" && zip != "" else {
            throw AddressError.InvalidAddress
        }
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zip
    }
    
    /**
     Change the street name and number
     
     - parameter street: the new street name and number
     
     - throws:   An error if the street is invalid
     */
    func changeStreet(street: String) throws {
        guard street != "" else {
            throw AddressError.InvalidStreet
        }
        self.street = street
    }
    
    /**
     Change the state
     
     - parameter state: the new state name
     
     - throws:  An error if the state is invalid
     */
    func changeState(state: String) throws {
        guard state != "" else {
            throw AddressError.InvalidState
        }
        self.state = state
    }
    
    /**
     Change the city
     
     - parameter city: the new city name
     
     - throws: An error if the city is invalid
     */
    func changeCity(city: String) throws {
        guard city != "" else {
            throw AddressError.InvalidCity
        }
        self.city = city
    }
    
    /**
     Change the zip code
     
     - parameter zip: the new zipcode
     
     - throws: An error if the zip in invalid
     */
    func changeZip(zip: String) throws {
        guard zip != "" else {
            throw AddressError.InvalidZip
        }
        self.zipCode = zip
    }
    
    class func parseClassName() -> String {
        return "Address"
    }
}





enum Departments: String {
    case Surgery = "Surgery"
    case ER = "ER"
    case Anesthetics = "Anesthetics"
    case Oncology = "Oncology"
    case Cardiology = "Cardiology"
    case CriticalCare = "CriticalCare"
    case Imaging = "Imaging"
    case ENT = "ENT"
    case Gynecology = "Gynecology"
    case Hematology = "Hematology"
    case Laboratory = "Laboratory"
    case Maternity = "Maternity"
    case Pediatrics = "Pediatrics"
    case Pharmacy = "Pharmacy"
    case Radiology = "Radiology"
}

enum DepartmentErrorCodes: ErrorType {
    case InvalidDepartmentName
}
//MARK: Department Class
/**
 Class for departments within the MIMS
 *  departmentName: String -- the name of the department
 *  Parse Class Name: "Department"
 */
class Department: PFObject, PFSubclassing {
    var departmentName: String? {
        get {
            return self["name"] as? String
        }
        
        set {
            self["name"] = newValue!
        }
    }
    
    /**
     A conveneince init with the department's name
     
     - parameter name: The department's name
     
     - returns:
     */
    convenience init(withName name: String) throws {
        self.init()
        if let department = Departments(rawValue: name) {
            self.departmentName = department.rawValue
        } else {
            throw DepartmentErrorCodes.InvalidDepartmentName
        }
    }
    
    class func parseClassName() -> String {
        return "Department"
    }
}

//MARK: Institution Class
/**
 *  A class for the institutions a user can belong to
 *  institutionName: String -- the instiution name
 *  Parse Class Name - "Institution"
 */
class Institution: PFObject, PFSubclassing {
    var institutionName: String? {
        get {
            return self["name"] as? String
        }
        set {
            self["name"] = newValue!
        }
    }
    
    /**
     Convenience init with the new institution name
     
     - parameter name: The institution name
     
     - returns:
     */
    convenience init(initWithName name: String) {
        self.init()
        self.institutionName = name
    }
    
    class func parseClassName() -> String {
        return "Institution"
    }
}


class Appointment: PFObject, PFSubclassing {
    
    var timeCreated: NSDate! {
        get { return self.createdAt }
    }
    
    var timeScheduled: NSDate! {
        get {
            return self["timeScheduled"] as! NSDate
        }
        set {
            if newValue != nil {
                self["timeScheduled"] = newValue!
            }
        }
    }
    
    var timeCompleted: NSDate? {
        get {return self["timeCompleted"] as? NSDate}
        set {if newValue != nil {self["timeCompleted"] = newValue!}}
    }
    
    var attendingPhysician: MIMSUser {
        get {
            return self["doctor"] as! MIMSUser
        }
        set {
                self["doctor"] = newValue
            }
    }
    
    var completed: Bool {
        get {return self["completed"] as! Bool}
        set{}
    }
    
    var associatedPatient: Patient {
        get {return self["patient"] as! Patient}
        set {self["patient"] = newValue}
    }
    
    var department: Department {
        get { return self["department"] as! Department }
        set {self["department"] = newValue }
    }
    
    var appointmentNotes: [String]? {
        get { return self["notes"] as? [String] }
        set {}
    }
    
    convenience init(initWithDoctor doctor: MIMSUser, patient: Patient, timeScheduled: NSDate, department: Department) {
        self.init()
        self.attendingPhysician = doctor
        self.associatedPatient = patient
        self.timeScheduled = timeScheduled
        self.department = department
        self.completed = false
    }
    
    func markAsCompleted() {
        completed = true
        self.timeCompleted = NSDate()
    }
    
    func reschedule(withNewDate date: NSDate) {
        if date > timeScheduled { timeScheduled = date }
    }
    
    class func parseClassName() -> String {
        return "Appointment"
    }
}
