//
//  ParseManager.swift
//  MIMS
//
//  Created by Patrick Bush on 4/15/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import Foundation
import Parse


enum ParseError: ErrorType {
    case InvalidUsernameLength(message: String)
    case InvalidPasswordLength(message: String)
    case InvalidKey(message: String)
}


class ParseClient {

    class func login(username: String, password: String, completion: (error: NSError?) ->()) throws {
        guard username.characters.count >= 6 else {
            throw ParseError.InvalidUsernameLength(message: "You didn't enter enough characters for your username")
        }
        
        guard password.characters.count >= 8 else {
            throw ParseError.InvalidPasswordLength(message: "You didn't enter enough characters for your password")
        }
        
        self.loginUser(username, password: password, completion: completion)
    }
    
    private class func loginUser(name: String, password: String, completion:(error: NSError?) ->()) {
        MIMSUser.logInWithUsernameInBackground(name, password: password) { (user, error) in
            if user != nil && error == nil {
                completion(error: nil)
            } else {
                completion(error: error!)
            }
        }
    }
    
    class func logout(user: PFUser, completion: (success: Bool, error: NSError?) ->()) {
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
        guard key.characters.count > 0 && key != "" else {
            throw ParseError.InvalidKey(message: "An invalid key/value was sent")
        }
        let query = MIMSUser.query()
        query?.whereKey(key, equalTo: value)
        query?.findObjectsInBackgroundWithBlock({ (objects, error) in
            if objects != nil && error == nil {
                completion(users: objects! as? [MIMSUser], error: nil)
            }
        })
    }
    
    class func queryPatients(key: String, value: String, completion: (patients: [Patient]?, error: NSError?) ->()) throws {
        guard value != "" && key != "" else {
            throw ParseError.InvalidKey(message: "An invalid key/value was sent")
        }
        let query = PFQuery(className: "Patient")
        query.whereKey(key, hasPrefix: value)
        query.findObjectsInBackgroundWithBlock { (patients, error) in
            if patients != nil && error == nil {
                completion(patients: patients as? [Patient], error: nil)
            } else {
                completion(patients: nil, error: error!)
            }
        }
    }
    
    class func queryPatientRecords(key: String, value: AnyObject, completion: (patientRecords: [PatientRecord]?, error: NSError?) ->()) {
        let query = PFQuery(className: "PatientRecord")
        query.whereKey(key, equalTo: value)
        query.findObjectsInBackgroundWithBlock { (patientRecords, error) in
            if patientRecords != nil && error == nil {
                completion(patientRecords: patientRecords as? [PatientRecord], error: nil)
            } else {
                completion(patientRecords: nil, error: error!)
            }
        }
    }
    
    class func queryDepartments(key: String, value: String, completion: (departments: Department?, error: NSError?) ->()) {
        let query = PFQuery(className: "Department")
        query.whereKey(key, equalTo: value)
        query.getFirstObjectInBackgroundWithBlock { (objects, error) in
            if error == nil && objects != nil {
                completion(departments: objects as? Department, error: nil)
            }
            else {
                completion(departments: nil, error: error!)
            }
        }
    }
    
    class func queryInstitutions(key: String, value: String, completion: (departments: Institution?, error: NSError?) ->()) {
        let query = PFQuery(className: "Institution")
        query.whereKey(key, equalTo: value)
        query.getFirstObjectInBackgroundWithBlock { (objects, error) in
            if error == nil && objects != nil {
                completion(departments: objects as? Institution, error: nil)
            }
            else {
                completion(departments: nil, error: error!)
            }
        }
    }
    
    class func queryAppointments(completion: (appointments: [Appointment]?, error: NSError?) ->()) {
        let query = PFQuery(className: "Appointment")
        query.whereKey("doctor", equalTo: MIMSUser.currentUser()!)
        query.includeKey("patient")
        query.findObjectsInBackgroundWithBlock { (appointments, error) in
            if error == nil && appointments!.count > 0 {
                completion(appointments: appointments as? [Appointment], error: nil)
            } else {
                completion(appointments: nil, error: error!)
            }
        }
    }
    
    class func deleteObject(objectToDelete: PFObject, completion: (success: Bool, error: NSError?)->()) {
        objectToDelete.deleteInBackgroundWithBlock { (success, error) in
            if success && error == nil {
                completion(success: true, error: nil)
            }
            else { completion(success: false, error: error!) }
        }
    }
    class func addPatientData() {
        let address = Address()
        try! address.newAddress("111 Test Street", city: "Auburn:", state: "AL", zip: "36832")
        let insuarnceInfo = try! InsuranceInfo(initWith: NSDate(), memID: "11111111", grpID: "13e90093", amount: 10)
        let finance = try! FinancialInformation(initWithAllInfo: "some user's payment info", balance: 10)
        let patient1 = try! Patient(initWithInfo: "John Doe", married: false, gender: true, birthday: NSDate(), ssn: "291822910", address: address, insuranceInfo: insuarnceInfo, financeData: finance, phoneNumber: "111-111-1111")
        patient1.saveEventually()
        let patientRecord = PatientRecord()
        patientRecord.patient = patient1
        patientRecord.saveEventually()
    }
    
    /**
     Method to be called when a patient is being admitted to the hospital for the first time.
     
     - parameter address:       The patient's address
     - parameter insuranceInfo: The patient's insurance info
     - parameter financeData:   The patient's finance data
     - parameter name:          The patient's name
     - parameter maritalStatus: The patient's maritial status
     - parameter gender:        The patient's gender
     - parameter birthday:      The patient's birthday
     - parameter ssn:           The patient's SSN
     - parameter completion:    A completion called upon successful or unsuccessful adding of the patient. If unsuccessful, the error message will not be empty and success will be false. Otherwise success will be true with an empty error message.
     */
    class func admitPatient(withPatientInfo address: Address, insuranceInfo: InsuranceInfo, financeInfo: FinancialInformation, name: String, maritalStatus: Bool, gender: Bool, birthday: NSDate, ssn: String, phone: String, completion: (success: Bool, errorMessage: String) ->()) {
        
        do {
            let newPatient = try Patient(initWithInfo: name, married: maritalStatus, gender: gender, birthday: birthday, ssn: ssn, address: address, insuranceInfo: insuranceInfo, financeData: financeInfo, phoneNumber: phone)
            let patientRecord = PatientRecord()
            patientRecord.patient = newPatient
            patientRecord.canBeDischarged = false
            patientRecord.active = true
            findDoctorToAssign({ (newDoctor, error) in
                if newDoctor != nil && error == nil {
                    patientRecord.attendingPhysician = newDoctor!
                    patientRecord.saveInBackgroundWithBlock({ (success, error) in
                        if success && error == nil {
                            completion(success: true, errorMessage: "")
                        } else {
                            completion(success: false, errorMessage: error!.localizedDescription)
                        }
                    })
                } else {
                    completion(success: false, errorMessage: "Unable to assign a new doctor!")
                }
            })
            
        } catch PatientError.InvalidSSN {
            completion(success: false, errorMessage: "You entered an invalid SSN. It must be exactly 9 characters.")
        } catch PatientError.InvalidName {
            completion(success: false, errorMessage: "You entered an invalid name. It cannot be empty.")
        } catch PatientError.InvalidBrthday {
            completion(success: false, errorMessage: "You entered an invalid birthday. The birthday must not be in the future.")
        } catch PatientError.InvalidPhoneNumber{
            completion(success: false, errorMessage: "You entered an invalid phone number. The number must be 11 characters.")
        }
        catch _ {
            completion(success: false, errorMessage: "An unknown error occured. Please try again.")
        }
    }
    
    /**
     Method to call when the "Delete patient record" button has been called. It makes the checks for whether or not the patient record is able to be deleted, so no need to worry about checking it yourself.
     
     - parameter record:     The patient record to be deleted
     - parameter completion: If successful, success will be true, and error will be nil, otherwise success will be false and error will contain the error with a "description" userInfo property to be accessed for the error message.
     */
    class func deletePatient(withPatientRecord record: PatientRecord, completion: (success: Bool, error: NSError?) ->()) {
        if record.canBeDischarged! {
            record.deleteInBackgroundWithBlock { (success, error) in
                if success && error == nil {
                    completion(success: true, error: nil)
                } else {
                    completion(success: false, error: error!)
                }
            }
        } else {
            let error = NSError(domain: "Patient", code: 001, userInfo: ["description": "The patient is not eleigible for discharge."])
            completion(success: false, error: error)
        }
    }
    
    /**
     Method to call when the "Charge Patient" button is pressed. It will clear out the patient's balance (in a real implementation it would do hella things like generate receipts and etc. but here we're just zeroing out and then saying that he patient is now able to be discharged.
     
     - parameter record:     The patient record
     - parameter patient:    The patient themself
     - parameter completion: Called with the success status
     */
    class func chargePatient(fromPatientRecord record: PatientRecord, andPatient patient: Patient, completion: (success: Bool) ->()) {
        patient.fetchInBackgroundWithBlock { (updatedPatient, error) in
            if error == nil {
                let financeData = (updatedPatient as! Patient).financials
                financeData?.clearBalance()
                record.canBeDischarged = true
                completion(success: true)
            } else {
                completion(success: false)
            }
        }
    }
    
    /**
     Method to call to manage a patient's insurance information. It takes the whole constructor and creates a new entry which is then returned
     
     - parameter date:        The expiration date
     - parameter memberID:    The member ID
     - parameter groupID:     The group ID
     - parameter copayAmount: The copay percentage
     - parameter completion:  Called with the new insurance record to be saved by the callee or an error if the record couldn't be generated.
     */
    class func managePatientInsurance(withExpirationDate date: NSDate, memberID: String, groupID: String, copayAmount: Int, completion: (insuranceInfo: InsuranceInfo?, error: String) ->()) {
        do {
            let newInsuranceInfo = try InsuranceInfo(initWith: date, memID: memberID, grpID: groupID, amount: copayAmount)
            completion(insuranceInfo: newInsuranceInfo, error: "")
            
        } catch InsuranceError.InvalidExpirationDate {
            completion(insuranceInfo: nil, error: "You entered an invalid expiration date! The policy cannot be expired already.")
        } catch InsuranceError.InvalidInsuranceInformation {
            completion(insuranceInfo: nil, error: "You entered invalid insurance information.")
        } catch _ {
            completion(insuranceInfo: nil, error: "An unknown error occured. Please try again.")
        }
    }
    
    /**
     Method to call when you want to discharge a patient. It checks if they can be discharged, adn if they can (meaning they're balance has previously been cleared (which isn't the best way to allow someone to leave ina real hospital system) and is now set to 0, then their status is set to active.
     
     - parameter patientRecord: The patient's record to discharge
     
     - returns: True if the patient is able to be discharged, false otherwise
     */
    class func dischargePatient(patientRecord: PatientRecord) ->Bool {
        
        if patientRecord.canBeDischarged! {
            patientRecord.changeActiveStatus(false)
            patientRecord.saveEventually()
            return true
        }
        return false
    }
    
    //TODO: Might have to work on this function. Currently only saves modified information but might need to make it more specific.
    class func saveModifiedPatientInfo(modifiedRecord: PatientRecord) {
        modifiedRecord.saveInBackground()
    }
    
    /**
     Method that should be called when new tests have been selected to add to the patient record.add
     
     - parameter newlyRequestedTests: The array of newly requested tests
     - parameter record:              The patient record
     */
    class func addPatientTests(newlyRequestedTests: [String], toPatientRecord record: PatientRecord) {
        for testDescription in newlyRequestedTests {
            record.addTest(newTest: Test(initWithTestDescription: testDescription))
        }
    }
    
    /**
     Method that should be called when you want to makr certain tests as completed
     
     - parameter newlyCompletedTests: The array of tests that should be marked as completed. These should have already been retrieved for display anyways, so just pass the value, no need to re-query
     - parameter record:              The patient record
     */
    class func markTestsAsCompleted(newlyCompletedTests: [Test], fromPatientRecord record: PatientRecord) {
        for test in newlyCompletedTests {
            test.completedStatus = true
            test.saveInBackground()
        }
    }
    
    /**
     Method to add new prescriptions to the patient record via the "treatments" property. The array of prescriptions needs to be precreated by the callee
     
     - parameter newlyRequestedScripts: The newly requested prescriptions
     - parameter record:                The patient record to add the prescriptions to
     - parameter completion:            Completion called with an error if the prescriptions can't be added, or nil otherwise.
     */
    class func addNewPrescription(newlyRequestedScripts: [Prescription], toRecord record: PatientRecord, completion: (error: NSError?)->()) {
        guard let treatments = record.treatments else {
            let error = NSError(domain: "Patient Treatments", code: 000, userInfo: ["description" : "Unable to retrieve treatments!"])
            completion(error: error)
            return
        }
        treatments.fetchInBackgroundWithBlock { (newTreatments, error) in
            if error == nil {
                for script in newlyRequestedScripts {
                    let scripts = treatments.prescriptions
                    var scriptDescriptions: [String]!
                    for script in scripts! {
                        scriptDescriptions.appendContentsOf(script.scripts!)
                    }
                    for description in scriptDescriptions {
                        if !(record.conditions?.allergies?.contains(description))! {
                            (newTreatments as! Treatment).addNewScript(script)
                        } else {
                            let error = NSError(domain: "Patient Treatments", code: 001, userInfo: ["description": "Can't prescribe a medication the patient is allergic to!"])
                            completion(error: error)
                        }
                    }
                }
                newTreatments?.saveEventually()
                completion(error: nil)
            } else {
                completion(error: error!)
            }
        }
    }
    
    /**
     Method to add new surgeries to the patient record via the "treatments" property. The array of surgeries needs to be created by the callee
     
     - parameter newlyRequeustedSurgeries: The new surgeries to add
     - parameter record:                   The patient record
     - parameter completion:               Completion called with error if unable to add the surgeries or nil otherwise
     */
    class func addNewSurgeries(newlyRequeustedSurgeries: [Surgery], toRecord record: PatientRecord, completion: (error: NSError?) ->()) {
        guard let treatments = record.treatments else {
            let error = NSError(domain: "Patient Treatments", code: 000, userInfo: ["description" : "Unable to retrieve treatments!"])
            completion(error: error)
            return
        }
        
        treatments.fetchInBackgroundWithBlock { (newTreatments, error) in
            if error == nil {
                for surgery in newlyRequeustedSurgeries {
                    (newTreatments as! Treatment).addSurgery(surgery)
                }
                newTreatments?.saveEventually()
                completion(error: nil)
            } else {
                completion(error: error!)
            }
        }
    }
    
    /**
     Method to add new immunizations to the patient record via the "treatments" property. The array of immunizations needs to be created by the callee
     
     - parameter newlyRequeustedImmunizations: The new immunizations to add
     - parameter record:                   The patient record
     - parameter completion:               Completion called with error if unable to add the immunizations or nil otherwise
     */
    class func addNewImmunizations(newlyRequeustedImmunizations: [Immunization], toRecord record: PatientRecord, completion: (error: NSError?) ->()) {
        guard let treatments = record.treatments else {
            let error = NSError(domain: "Patient Treatments", code: 000, userInfo: ["description" : "Unable to retrieve treatments!"])
            completion(error: error)
            return
        }
        
        treatments.fetchInBackgroundWithBlock { (newTreatments, error) in
            if error == nil {
                for immunization in newlyRequeustedImmunizations {
                    (newTreatments as! Treatment).addImmunization(immunization)
                }
                newTreatments?.saveEventually()
                completion(error: nil)
            } else {
                completion(error: error!)
            }
        }
    }
    
    /**
     Method to add allergies to the patient record.
     
     - parameter newAllergies: The new allergies names to add
     - parameter record:       The patient record to add to
     
     - returns: An error if the allergy name is invalid or if there is some other unknown error.
     */
    class func addAllergies(newAllergies: [String], toPatientRecord record: PatientRecord) -> NSError? {
        var error: NSError?
        for allergy in newAllergies {
            do {
                try record.conditions?.addAllergy(allergy)
            } catch ConditionError.InvalidAllergy {
                error = NSError(domain: "Condition error", code: 000, userInfo: ["description" : "Bad allergy name."])
            } catch _ {
                error = NSError(domain: "Condition error", code: 001, userInfo: ["description" : "Unknown allergy error"])
            }
        }
        record.saveEventually()
        return error
    }
    
    /**
     Method to add disorders to the patient record.
     
     - parameter newDisorders: The new disorder names to add
     - parameter record:       The patient record to add to
     
     - returns: An error if the disorder name is invalid or if there is some unknown error, nil otherwise
     */
    class func addDisorders(newDisorders: [String], toPatientRecord record: PatientRecord) -> NSError? {
        var error: NSError?
        for disorder in newDisorders {
            do {
                try record.conditions?.addDisorder(disorder)
            } catch ConditionError.InvalidDisorder {
                error = NSError(domain: "Condition error", code: 000, userInfo: ["description" : "Bad disorder name."])
            } catch _ {
                error = NSError(domain: "Condition error", code: 001, userInfo: ["description" : "Unknown disorder error"])
            }
        }
        record.saveEventually()
        return error
    }
    
    /**
     Method to add diseases to the patient record.
     
     - parameter newDiseases: The new diseases to add
     - parameter record:      The patient record to add to
     
     - returns: An error if the disease name is invalid or nil otherwise
     */
    class func addDiseases(newDiseases: [String], toPatientRecord record: PatientRecord) -> NSError? {
        var error: NSError?
        for disease in newDiseases {
            do {
                try record.conditions?.addDisease(disease)
            } catch ConditionError.InvalidDisease {
                error = NSError(domain: "Condition error", code: 000, userInfo: ["description": "Bad disease name."])
            } catch _ {
                error = NSError(domain: "Condition error", code: 001, userInfo: ["description": "Unknown disease error"])
            }
        }
        record.saveEventually()
        return error
    }
    
    /**
     Method to add a new cause of death. Can only be assigned if a cause of death hasn't already been assigned
     
     - parameter newCOD: The new newCOD
     - parameter record: The patient record
     
     - returns: An error if unable to add the record
     */
    class func addNewCauseOfDeath(newCOD cod: String, toPatientRecord record: PatientRecord) -> NSError? {
        var error: NSError?
        if let _ = record.conditions?.causeOfDeath {
            error = NSError(domain: "Condition error", code: 004, userInfo: ["description": "Cause of Death can only be assigned once! Patient cannot die more than once."])
            return error
        }
        do {
            try record.conditions?.addCauseOfDeath(cod)
        } catch ConditionError.InvalidCOD {
            error = NSError(domain: "Condition error", code: 002, userInfo: ["description": "Invalid cause of death"])
            return error
        } catch _ {
            error = NSError(domain: "Condition error", code: 003, userInfo: ["description": "Unknown cause of death error"])
            return error
        }
        return nil
    }
    
    /**
     Method to try to transfer a patient to another doctor. Will check if the name is valid and if it is will assign the new doctor, otherwise it will return an error.
     
     - parameter name:       The name of the new doctor to assign the patient to
     - parameter record:     The patient record
     - parameter completion: Called with the result, success if a doctor was found, or error otherwise
     */
    class func transferPatient(toNewDoctorWithName name: String, withPatientRecord record: PatientRecord, completion: (success: Bool, error: NSError?) ->()) {
        do {
            try queryUsers("name", value: name, completion: { (users, error) in
                if users != nil && error == nil {
                    record.attendingPhysician = users!.first!
                    completion(success: true, error: nil)
                } else {
                    completion(success: false, error: error!)
                }
            })
        } catch ParseError.InvalidKey(message: _) {
            let error = NSError(domain: "User query", code: 000, userInfo: ["description": "No doctor found with name to reassign"])
            completion(success: false, error: error)
        } catch _ {
            let error = NSError(domain: "User query", code: 001, userInfo: ["description": "An unknown user query error occured."])
            completion(success: false, error: error)
        }
    }
    
    /**
     Method to add a new set of scans to the patient record.
     
     - parameter newlyRequestedScans: The set of newly requeusted scans
     - parameter record:              The patient record to add to
     */
    class func addScan(newlyRequestedScans: [Scan], toPatientRecord record: PatientRecord) {
        for scan in newlyRequestedScans {
            record.addScan(newScan: scan)
        }
    }
    
    /**
     A private function to find a random doctor to assign to a new patient. Not the best implemetation of finding a doctor to assign but ya know, it will do.
     
     - parameter completion: If there's a new doctor to assign, the parameter will be filled, otherwise there will be an error.
     */
    private class func findDoctorToAssign(completion: (newDoctor: MIMSUser?, error: NSError?) ->()) {
        let count = PFUser.query()!
        count.countObjectsInBackgroundWithBlock { (countedUsers, error) in
            if error == nil {
                let query = PFUser.query()!
                query.whereKey("userType", equalTo: UserTypes.OperationalUser.rawValue)
                query.limit = 1
                query.skip = Int(arc4random_uniform(UInt32(countedUsers))+0)
                query.getFirstObjectInBackgroundWithBlock({ (newDoctor, error) in
                    if error == nil && newDoctor != nil {
                        completion(newDoctor: newDoctor as? MIMSUser, error: nil)
                    } else {
                        completion(newDoctor: nil, error: error!)
                    }
                })
                
            } else {
                completion(newDoctor: nil, error: error!)
            }
        }
    }
    
    /**
     A private function to find a random pharmacist to assign to a new prescription.
     
     - parameter completion: A new pharmacist to assign to the prescription, or an error if one can't be found.
     */
    private class func findPharmacistToAssign(completion: (newPharmacist: MIMSUser?, error: NSError?) ->()) {
        let department = try! Department(withName: "Pharmacy")
        let count = PFUser.query()!
        count.countObjectsInBackgroundWithBlock { (countedUsers, error) in
            if error == nil {
                let query = PFUser.query()!
                query.whereKey("userType", equalTo: UserTypes.TechnicalUser.rawValue)
                query.whereKey("department", equalTo: department)
                query.limit = 1
                query.skip = Int(arc4random_uniform(UInt32(countedUsers))+0)
                query.getFirstObjectInBackgroundWithBlock({ (pharmacist, error) in
                    if error == nil && pharmacist != nil {
                        completion(newPharmacist: pharmacist as? MIMSUser, error: nil)
                    } else {
                        completion(newPharmacist: nil, error: error!)
                    }
                })
                
            } else {
                completion(newPharmacist: nil, error: error!)
            }
        }
    }
}