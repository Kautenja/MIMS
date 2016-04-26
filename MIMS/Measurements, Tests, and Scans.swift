//
//  Measurements, Tests, and Scans.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/25/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import Foundation
import Parse

enum MeasurementError: ErrorType {
    case InvalidBloodPressure
    case InvalidHeight
}

//MARK: Measurement Class
/**
 A class for the various measurements that can be taken
 *  timeTaken: NSDate -- the time the measurement was taken
 *  timeCreated: NSDate -- the time the measurement request was created
 *  timeModified: NSDate -- the time a measurement was last modified
 *  private systolic: Int -- a patient's systolic
 *  private diastolic: Int -- a patient's diastolic
 *  bloodPressure: String -- the patient's blood pressure, a computed value
 *  private inches: Int -- the patient's inches
 *  private feet: Int -- the patient's feet
 *  height: String -- the height of the patient, a computed value
 *  Parse Class Name: "Measurement"
 */
class Measurement: PFObject, PFSubclassing {
    
    var timeTaken: NSDate? {
        get {
            return self["timeTaken"] as? NSDate
        }
        set {
            if newValue != nil {
                self["timeTaken"] = newValue!
            }
        }
    }
    
    var timeCreated: NSDate? {
        get {
            return self.createdAt
        }
    }
    
    var timeModified: NSDate? {
        get {
            return self.updatedAt
        }
    }
    
    private var systolic: Int? {
        get {
            return self["systolic"] as? Int
        }
        set {
            if newValue > 0 {
                self["systolic"] = newValue!
            }
        }
    }
    
    private var diastolic: Int? {
        get {
            return self["diastolic"] as? Int
        }
        set {
            if newValue > 0 {
                self["diastolic"] = newValue!
            }
        }
    }
    
    var bloodPressure: String {
        return "\(String(systolic!))/\(String(diastolic!)))" ?? ""
    }
    
    private var feet: Int? {
        get {
            return self["heightFeet"] as? Int
        }
        set {
            if newValue > 0 && newValue <= 10 {
                self["heightFeet"] = newValue!
            }
        }
    }
    
    private var inches: Int? {
        get {
            return self["heightInches"] as? Int
        }
        set {
            if newValue > 0 && newValue < 12 {
                self["heightInches"] = newValue!
            }
        }
    }
    
    var height: String {
        return "\(String(feet!)) feet, \(String(inches!)) inches" ?? ""
    }
    
    var weight: Double? {
        get {
            return self["weight"] as? Double
        }
        set {
            if newValue > 0 {
                self["weight"] = newValue!
            }
        }
    }
    
    /**
     Add a new blood pressure for a patient. These should never be  modified seperately,
     and always be added in this manner to ensure accurate measurements.
     
     - parameter systolic:  The patient's new systolic number
     - parameter diastolic: The patient's new diastolic number
     */
    func addNewBloodPressure(systolic: Int, diastolic: Int) throws {
        guard systolic > 0 && systolic < 300 && diastolic > 0 && diastolic < 200 else {
            throw MeasurementError.InvalidBloodPressure
        }
        self.systolic = systolic
        self.diastolic = diastolic
    }
    
    /**
     Add a new height for the patient. These should also never be modified seperately,
     and always be added in this manner to ensure accurate measurements.
     
     - parameter feet:   The patient's height in feet
     - parameter inches: The patient's height in inches
     */
    func addHeight(feet: Int, inches: Int) throws {
        guard feet > 0 && feet <= 10 && inches > 0 && inches < 12 else {
            throw MeasurementError.InvalidHeight
        }
        self.feet = feet
        self.inches = inches
    }
    
    class func parseClassName() -> String {
        return "Measurement"
    }
}

//MARK: Test Class

class Test: PFObject, PFSubclassing {
    
    var timeCreated: NSDate? {
        get {return self.createdAt}
    }
    
    var timeModified: NSDate? {
        get {return self.updatedAt}
        set {}
    }
    
    var timeStarted: NSDate? {
        get {return self["timeStarted"] as? NSDate}
        set{if newValue != nil {self["timeStarted"] = newValue!}}
    }
    
    var timeCompleted: NSDate? {
        get {return self["timeCompleted"] as? NSDate}
        set {if newValue != nil {self["timeCompleted"] = newValue!}}
    }
    
    
    var testDescription: String? {
        get {return self["testDescription"] as? String}
        set { if newValue != nil { self["testDescription"] = newValue! } }
    }
    
    var completedStatus: Bool? {
        get { return self["completed"] as? Bool }
        set { if newValue != nil {self["completed"] = newValue! }}
    }
    
    convenience init(initWithTestDescription description: String) {
        self.init()
        self.testDescription = description
        self.completedStatus = false
    }
    
    func changeCompletionStatus(newStatus: Bool, timeCompleted: NSDate) {
        self.completedStatus = newStatus
        self.timeCompleted = timeCompleted
    }
    
    func markAsStarted(startTime: NSDate) ->Bool {
        if !completedStatus! {
            self.timeStarted = startTime
            return true
        }
        return false
    }
    
    class func parseClassName() -> String {
        return "Test"
    }
}

class Scan: PFObject, PFSubclassing {
    var timeCreated: NSDate? {
        get {return self.createdAt }
    }
    
    var timeModified: NSDate? {
        get {return self.updatedAt }
        set {}
    }
    
    var timeStarted: NSDate? {
        get {return self["timeStarted"] as? NSDate}
        set{if newValue != nil {self["timeStarted"] = newValue!}}
    }
    
    var timeCompleted: NSDate? {
        get {return self["timeCompleted"] as? NSDate}
        set {if newValue != nil {self["timeCompleted"] = newValue!}}
    }
    
    var scanType: String? {
        get {return self["scanType"] as? String }
        set { if newValue != nil {self["scanType"] = newValue!} }
    }
    
    var completedStatus: Bool? {
        get { return self["completed"] as? Bool }
        set { if newValue != nil {self["completed"] = newValue! }}
    }
    
    convenience init(initWithType type: String) {
        self.init()
        self.scanType = type
        self.completedStatus = false
    }
    
    func changeCompletionStatus(newStatus: Bool, timeCompleted: NSDate) {
        self.completedStatus = newStatus
        self.timeCompleted = timeCompleted
    }
    
    func markAsStarted(startTime: NSDate) {
        self.timeStarted = startTime
    }
    
    class func parseClassName() -> String {
        return "Scan"
    }
}
