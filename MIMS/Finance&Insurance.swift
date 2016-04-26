//
//  Finance&Insurance.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/25/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import Foundation
import Parse

enum FinanceError: ErrorType {
    case InvalidBalance
    case InvalidPaymentInfo
}

//MARK: Financial Information Class
/**
 *  paymentInfo: String -- the patient's payment info
 *  outstandingBalance: Int -- the patient's outstanding balance
 *  Parse Class Name: "Financial Information"
 */
class FinancialInformation: PFObject, PFSubclassing {
    
    var paymentInfo: String? {
        get {
            return self["paymentInfo"] as? String
        }
        set {
            if newValue != nil && newValue != "" {
                self["paymentInfo"] = newValue!
            }
        }
    }
    
    var outstandingBalance: Double? {
        get {
            return self["outstandingBalance"] as? Double
        }
        set {
            if newValue != nil && newValue >= 0 {
                self["outstandingBalance"] = newValue!
                self.goodStanding = false
            }
        }
    }
    
    var goodStanding: Bool? {
        get {return self["standing"] as? Bool}
        set{if newValue != nil {self["standing"] = newValue!}}
    }
    
    /**
     A convenience init with just payment info. Sets default balance to 0
     
     - parameter paymentInfo: the new payment info
     
     - returns: A new FinancialInformation object
     */
    convenience init(initWithPaymentInfo paymentInfo: String) throws {
        self.init()
        if paymentInfo == "" {
            throw FinanceError.InvalidPaymentInfo
        }
        self.paymentInfo = paymentInfo
        self.outstandingBalance = 0
        self.goodStanding = true
    }
    
    /**
     A conveneince init with all info
     
     - parameter paymentInfo: The new payment info
     - parameter balance:     the outstanding balance
     
     - returns: A new FinancialInformation object
     */
    convenience init(initWithAllInfo paymentInfo: String, balance: Double) throws {
        self.init()
        guard paymentInfo != "" else {
            throw FinanceError.InvalidPaymentInfo
        }
        guard balance >= 0 else {
            throw FinanceError.InvalidBalance
        }
        self.paymentInfo = paymentInfo
        self.outstandingBalance = balance
        self.goodStanding = true
        if balance > 0 {
            self.goodStanding = false
        }
    }
    
    func clearBalance() {
        self.outstandingBalance = 0
        self.goodStanding = true
    }
    
    func inGoodStanding() -> Bool {
        return goodStanding!
    }
    
    class func parseClassName() -> String {
        return "FinancialInformation"
    }
}

enum InsuranceError: ErrorType {
    case InvalidInsuranceInformation
    case InvalidExpirationDate
}
//MARK: Insurance Info Class
/**
 *  Class for maintaining the patient's insurance info
 *  expirationData: NSDate -- the expiration date for the user
 *  memberID: String -- the id for the patient
 *  groupID: String -- the group ID for the patient
 *  copay: Int -- the copay %
 *  Parse Class Name: "Insurance Information"
 */
class InsuranceInfo: PFObject, PFSubclassing {
    
    var expirationDate: NSDate? {
        get {
            return self["expiryDate"] as? NSDate
        }
        set {
            if newValue != nil {
                self["expiryDate"] = newValue!
            }
        }
    }
    
    var memberID: String? {
        get {
            return self["id"] as? String
        }
        set {
            if newValue != nil && newValue != "" {
                self["id"] = newValue!
            }
        }
    }
    
    var groupID: String? {
        get {
            return self["groupID"] as? String
        }
        set {
            if newValue != nil && newValue != "" {
                self["groupID"] = newValue!
            }
        }
    }
    
    
    var copay: Int? {
        get {
            return self["copay"] as? Int
        }
        set {
            if newValue != nil && newValue >= 0 {
                self["copay"] = newValue!
            }
        }
    }
    
    /**
     Convenience init for adding new insurance information
     
     - parameter expiryDate: The insurance policy's expiration date
     - parameter memID:      The insurance policy's member ID
     - parameter grpID:      The insurance policy's group ID
     - parameter amount:     The insurance policy's copay %
     
     - throws:  An error if the information is invalid
     
     - returns: a new InsuranceInformation object
     */
    convenience init(initWith expiryDate: NSDate, memID: String, grpID: String, amount: Int) throws {
        self.init()
        guard memID != "" && grpID != "" && amount >= 0 else {
            throw InsuranceError.InvalidInsuranceInformation
        }
        guard NSDate() >= expiryDate else {
            throw InsuranceError.InvalidExpirationDate
        }
        self.expirationDate = expiryDate
        self.memberID = memID
        self.groupID = grpID
        self.copay = amount
    }
    
    func isExpired() -> Bool {
        return expirationDate < NSDate()
    }
    
    class func parseClassName() ->String {
        return "InsuranceInformation"
    }
}