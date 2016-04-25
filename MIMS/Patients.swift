//
//  Patients.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/25/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import Foundation
import Parse

//MARK: Patient Record Class
/**
 *  A class for the Patient record
 *  Member variables
 *  patient: Patient -- the corresponding patient
 *  appointments: [Appointment] -- the appointments scheduled for the patient
 *  treatments: [Treatment] -- the treatments the patient has had or has scheduled
 *  comments: [String] -- any comments on the patient file
 *  measurements: [Measurements] -- measurements taken on the patient
 *  scans: [Scans] -- scans taken on the patient
 *  tests: [Tests] -- tests taken on the patient
 *  Parse Class Name: "Patient Record"
 */
class PatientRecord: PFObject, PFSubclassing {
    
    var patient: Patient? {
        get {
            return self["patient"] as? Patient
        }
        set {
            if newValue != nil {
                self["patient"] = newValue!
            }
        }
    }
    
    var appointments: [Appointment]? {
        get {
            return self["appointments"] as? [Appointment]
        }
        set {}
    }
    
    //Should only have one treatment object, which can have arrays of prescriptions, immunizations, and surgeries
    var treatments: Treatment? {
        get {
            return self["treatments"] as? Treatment
        }
        set {if newValue != nil {self["treatments"] = newValue! }}
    }
    
    var comments: [String]? {
        get {
            return self["comments"] as? [String]
        }
        set{}
    }
    
    //measurements
    var measurements: Measurement? {
        get {
            return self["measurements"] as? Measurement
        }
        set {
            if newValue != nil {
                self["measurements"] = newValue!
            }
        }
    }
    
    var conditions: Condition? {
        get {
            return self["conditions"] as? Condition
        }
        set{
            if newValue != nil {
                self["conditions"] = newValue!
            }
        }
    }
    
    var canBeDischarged: Bool? {
        get {
            return self["dischargeStatus"] as? Bool
        }
        set {
            self["dischargeStatus"] = newValue!
        }
    }
    
    var active: Bool {
        get {return self["activeStatus"] as! Bool}
        set{self["activeStatus"] = newValue}
    }
    
    //scans
    var scansTaken: [Scan]? {
        get {return self["scans"] as? [Scan] }
        set {}
    }
    
    
    //tests
    var testsTaken: [Test]? {
        get {return self["tests"] as? [Test]}
        set {}
    }
    
    var attendingPhysician: MIMSUser {
        get {return self["doctor"] as! MIMSUser}
        set {self["doctor"] = newValue}
    }
    
    func addAppointment(newAppointment: Appointment) {
        self.appointments?.append(newAppointment)
    }
    
    func addComment(newComment: String) {
        self.comments?.append(newComment)
    }
    
    func changeDischargeStatus(newStatus: Bool) {
        self.canBeDischarged = newStatus
    }
    
    func changeActiveStatus(newStatus: Bool) {
        self.active = newStatus
    }
    
    func addScan(newScan scan: Scan) {
        self.scansTaken?.append(scan)
    }
    
    func addTest(newTest test: Test) {
        self.testsTaken?.append(test)
    }
    
    
    
    class func parseClassName() -> String {
        return "PatientRecord"
    }
}

enum PatientError: ErrorType {
    case InvalidBrthday
    case InvalidSSN
    case InvalidName
    case InvalidPhoneNumber
}

//MARK: Patient Class
/**
 A class that holds patient metadata information
 *  name: String -- The name of the patient
 *  married: Bool -- The marriage status (1 is married, 0 is single)
 *  gender: Bool -- The gender of the patient (1 is Male, 0 is female)
 *  birthday: NSDate -- the birthday of the patient
 *  ssn: String -- the SSN of the patient
 *  address: Address -- the patient's address
 *  insurance: Insurance -- the patient's insurance info
 *  financials: FinancialInformation -- the patient's financial info
 *  Parse Class Name: "Patient"
 */
class Patient: PFObject, PFSubclassing {
    
    var name: String? {
        get {
            return self["name"] as? String
        }
        set {
            if newValue?.characters.count > 0 {
                self["name"] = newValue!
            }
        }
    }
    
    var married: Bool? {
        get {
            return self["maritialStatus"] as? Bool
        }
        set {
            if newValue != nil {
                self["maritialStatus"] = newValue!
            }
        }
    }
    
    //Male is 1, female is 0
    var gender: Bool? {
        get {
            return self["gender"] as? Bool
        }
        set {
            if newValue != nil {
                self["gender"] = newValue!
            }
        }
    }
    
    var birthday: NSDate? {
        get {
            return self["birthday"] as? NSDate
        }
        set {
            if newValue != nil && newValue <= NSDate() {
                self["birthday"] = newValue!
            }
        }
    }
    
    var ssn: String? {
        get {
            return self["ssn"] as? String
        }
        set {
            if newValue?.characters.count == 9 {
                self["ssn"] = newValue!
            }
        }
    }
    
    var address: Address? {
        get {
            return self["address"] as? Address
        }
        set {
            if newValue != nil {
                self["address"] = newValue!
            }
        }
    }
    
    var insurance: InsuranceInfo? {
        get {
            return self["insuranceInfo"] as? InsuranceInfo
        }
        set {
            if newValue != nil {
                self["insuranceInfo"] = newValue!
            }
        }
    }
    
    var phoneNumber: String? {
        get {return self["phone"] as? String}
        set {if newValue != nil {self["phone"] = newValue!}}
    }
    
    var financials: FinancialInformation? {
        get {
            return self["financialData"] as? FinancialInformation
        }
        set {
            if newValue != nil {
                self["financialData"] = newValue!
            }
        }
    }
    
    /**
     A convenience init for a new patient. Requires address, insurance info, and financeData
     
     - parameter name:          The patient's name
     - parameter married:       The patient's marriage status
     - parameter gender:        The patient's gender
     - parameter ssn:           The patient's SSN
     - parameter address:       The patient's address
     - parameter insuranceInfo: The patient's insurance info
     - parameter financeData:   The patient's finance data
     
     -throws: Patient Error.InvalidBirthday, PatientError.InvalidSSN, PatientError.InvalidName
     - returns:
     */
    convenience init(initWithInfo name: String, married: Bool, gender: Bool, birthday: NSDate, ssn: String, address: Address, insuranceInfo: InsuranceInfo, financeData: FinancialInformation, phoneNumber: String) throws {
        guard birthday <= NSDate() else {
            throw PatientError.InvalidBrthday
        }
        guard ssn.characters.count == 9 else {
            throw PatientError.InvalidSSN
        }
        guard name.characters.count > 0 else {
            throw PatientError.InvalidName
        }
        guard phoneNumber.characters.count == 11 else {
            throw PatientError.InvalidPhoneNumber
        }
        
        self.init()
        self.name = name
        self.married = married
        self.gender = gender
        self.birthday = birthday
        self.ssn = ssn
        self.address = address
        self.insurance = insuranceInfo
        self.financials = financeData
    }
    
    /**
     A convenience init for a new patient. Requires address
     Use this init for patient's without insurance
     
     - parameter name:          The patient's name
     - parameter married:       The patient's marriage status
     - parameter gender:        The patient's gender
     - parameter ssn:           The patient's SSN
     - parameter address:       The patient's address
     - parameter insuranceInfo: The patient's insurance info
     - parameter financeData:   The patient's finance data
     
     - returns:
     */
    convenience init(initWithLessInfo name: String, married: Bool, gender: Bool, birthday: NSDate, ssn: String, address: Address) throws {
        guard birthday <= NSDate() else {
            throw PatientError.InvalidBrthday
        }
        guard ssn.characters.count == 9 else {
            throw PatientError.InvalidSSN
        }
        guard name.characters.count > 0 else {
            throw PatientError.InvalidName
        }
        self.init()
        self.name = name
        self.married = married
        self.gender = gender
        self.ssn = ssn
        self.address = address
    }
    
    class func parseClassName() -> String {
        return "Patient"
    }
    
}