//
//  Treatments.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/25/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import Foundation
import Parse

//MARK: Treatment Abstract Class
/**
 An abstract class that treatments can inheirt from
 *  timeCreated: NSDate -- the time the treatment was created
 *  Parse Class Name: "Treatment"
 */
class Treatment: PFObject, PFSubclassing {
    
    var timeCreated: NSDate? {
        get {
            return self.createdAt
        }
    }
    
    var prescriptions: [Prescription]? {
        get {return self["prescriptions"] as? [Prescription] }
        set {if newValue != nil { self["prescriptions"] = newValue! } }
    }
    
    var surgeries: [Surgery]? {
        get {return self["surgeries"] as? [Surgery] }
        set { if newValue != nil { self["surgeries"] = newValue! } }
    }
    
    var immunizations: [Immunization]? {
        get {return self["immunizations"] as? [Immunization]}
        set {if newValue != nil {self["immunizations"] = newValue! } }
    }
    
    func addNewScript(script: Prescription) {
        self.prescriptions?.append(script)
    }
    
    func addSurgery(surgery: Surgery) {
        self.surgeries?.append(surgery)
    }
    
    func addImmunization(immunization: Immunization) {
        self.immunizations?.append(immunization)
    }
    
    class func parseClassName() -> String {
        return "Treatment"
    }
    
    
}

//MARK: Treatment subclass Prescription
/**
 A class representing the precriptions filled
 *  timeReceived: NSDate -- the time the prescription was received by the pharmacist
 *  timeFilled: NSDate -- the time the prescription was done being filled
 *  pharmacist: MIMSUser -- the pharmacist who filled the script
 *  scripts: [String] -- the prescription(s) filled
 */
class Prescription: PFObject, PFSubclassing  {
    
    var timeReceived: NSDate? {
        get {
            return self["timeReceived"] as? NSDate
        }
        set {
            if newValue != nil {
                self["timeReceived"] = newValue!
            }
        }
    }
    
    var timeFilled: NSDate? {
        get {
            return self["timeFilled"] as? NSDate
        }
        set {
            if newValue != nil {
                self["timeFilled"] = newValue!
            }
        }
    }
    
    var pharmacist: MIMSUser? {
        get {
            return self["pharmacist"] as? MIMSUser
        }
        set {
            if newValue != nil {
                self["pharmacist"] = newValue!
            }
        }
    }
    
    var scripts: [String]? {
        get {
            return self["name"] as? [String]
        }
        set {}
    }
    
    var fillStatus: Bool? {
        get {
            return self["fillStatus"] as? Bool
        }
        set {
            if newValue != nil {
                self["fillStatus"] = newValue!
            }
        }
    }
    
    convenience init(withPharmacist pharmacist: MIMSUser, newScript: String) {
        self.init()
        self.pharmacist = pharmacist
        self.scripts = [newScript]
        self.fillStatus = false
    }
    
    func addPrescriptionName(name: String) {
        self.scripts?.append(name)
    }
    
    func changePharmacist(newPharmacist: MIMSUser) {
        self.pharmacist = newPharmacist
    }
    
    func markPrescriptionAsFilled() {
        self.timeFilled = NSDate()
        self.fillStatus = true
    }
    
    func markPrescriptionAsFilled(withDate date: NSDate) {
        self.timeFilled = date
        self.fillStatus = true
    }
    
    func markPrescriptionAsReceived() {
        self.timeReceived = NSDate()
    }
    
    func markPrescriptionAsReceived(withDate date: NSDate) {
        self.timeReceived = date
    }
    
    class func parseClassName() -> String {
        return "Prescription"
    }
    
}

//MARK: Surgery class
/**
 *  attendingSurgeon: MIMSUser -- the surgeon working on the patient
 */
class Surgery: PFObject, PFSubclassing {
    var attendingSurgeon: MIMSUser? {
        get {
            return self["attendingSurgeon"] as? MIMSUser
        }
        set {
            if newValue != nil {
                self["attendingSurgeon"] = newValue!
            }
        }
    }
    
    convenience init(withSurgeon surgeon: MIMSUser) {
        self.init()
        self.attendingSurgeon = surgeon
    }
    
    class func parseClassName() -> String {
        return "Surgery"
    }
}

//MARK: Immunization Class
/**
 *  immunizationTypes: String -- the types of immunizations received
 */
class Immunization: PFObject, PFSubclassing  {
    var immunizationTypes: [String]? {
        get {
            return self["immunizations"] as? [String]
        }
        set {}
    }
    
    convenience init(withImmunizationType immunization: String) {
        self.init()
        self.immunizationTypes = [immunization]
    }
    
    func addNewImmunization(immunization: String) {
        self.immunizationTypes?.append(immunization)
    }
    
    class func parseClassName() -> String {
        return "Immunization"
    }
}

