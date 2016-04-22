//
//  ParseManager.swift
//  MIMS
//
//  Created by Patrick Bush on 4/15/16.
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
    
    var treatments: [Treatment]? {
        get {
            return self["treatments"] as? [Treatment]
        }
        set {}
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
    
    //scans
    
    
    //tests
    
    func addAppointment(newAppointment: Appointment) {
        self.appointments?.append(newAppointment)
    }
    
    func addComment(newComment: String) {
        self.comments?.append(newComment)
    }
    
    func addNewTreatment(newTreatment: Treatment) {
        self.treatments?.append(newTreatment)
    }
    
    
    class func parseClassName() -> String {
        return "Patient Record"
    }
}

enum FinanceErrors: ErrorType {
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
    
    var outstandingBalance: Int? {
        get {
            return self["outstandingBalance"] as? Int
        }
        set {
            if newValue != nil && newValue >= 0 {
                self["outstandingBalance"] = newValue!
            }
        }
    }
    
    /**
     A convenience init with just payment info. Sets default balance to 0
     
     - parameter paymentInfo: the new payment info
     
     - returns: A new FinancialInformation object
     */
    convenience init(initWithPaymentInfo paymentInfo: String) throws {
        self.init()
        if paymentInfo == "" {
            throw FinanceErrors.InvalidPaymentInfo
        }
        self.paymentInfo = paymentInfo
        self.outstandingBalance = 0
    }
    
    /**
     A conveneince init with all info
     
     - parameter paymentInfo: The new payment info
     - parameter balance:     the outstanding balance
     
     - returns: A new FinancialInformation object
     */
    convenience init(initWithAllInfo paymentInfo: String, balance: Int) throws {
        self.init()
        guard paymentInfo != "" else {
            throw FinanceErrors.InvalidPaymentInfo
        }
        guard balance >= 0 else {
            throw FinanceErrors.InvalidBalance
        }
        self.paymentInfo = paymentInfo
        self.outstandingBalance = balance
    }
    
    class func parseClassName() -> String {
        return "Financial Information"
    }
}

enum AddressErrors: ErrorType {
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
            throw AddressErrors.InvalidAddress
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
            throw AddressErrors.InvalidStreet
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
            throw AddressErrors.InvalidState
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
            throw AddressErrors.InvalidCity
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
            throw AddressErrors.InvalidZip
        }
        self.zipCode = zip
    }
    
    class func parseClassName() -> String {
        return "Address"
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
    
    
    class func parseClassName() ->String {
        return "Insurance Information"
    }
}

enum PatientErrors: ErrorType {
    case InvalidBrthday
    case InvalidSSN
    case InvalidName
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
     
     - returns:
     */
    convenience init(initWithInfo name: String, married: Bool, gender: Bool, birthday: NSDate, ssn: String, address: Address, insuranceInfo: InsuranceInfo, financeData: FinancialInformation) throws {
        guard birthday <= NSDate() else {
            throw PatientErrors.InvalidBrthday
        }
        guard ssn.characters.count == 9 else {
            throw PatientErrors.InvalidSSN
        }
        guard name.characters.count > 0 else {
            throw PatientErrors.InvalidName
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
            throw PatientErrors.InvalidBrthday
        }
        guard ssn.characters.count == 9 else {
            throw PatientErrors.InvalidSSN
        }
        guard name.characters.count > 0 else {
            throw PatientErrors.InvalidName
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
class Prescription: Treatment {
    
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

}

//MARK: Surgery class
/**
 *  attendingSurgeon: MIMSUser -- the surgeon working on the patient
 */
class Surgery: Treatment {
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
}

//MARK: Immunization Class
/**
 *  immunizationTypes: String -- the types of immunizations received
 */
class Immunization: Treatment {
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
}

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
            if newValue > 0 && newValue <= 8 {
                self["heightFeet"] = newValue!
            }
        }
    }
    
    private var inches: Int? {
        get {
            return self["heightInches"] as? Int
        }
        set {
            if newValue > 0 && newValue <= 12 {
                self["heightInches"] = newValue!
            }
        }
    }
    
    var height: String {
        return "\(String(feet!)) feet, \(String(inches!)) inches" ?? ""
    }
    
    var weight: Int? {
        get {
            return self["weight"] as? Int
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
        guard systolic > 0 && systolic < 200 && diastolic > 0 && diastolic < 160 else {
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
        guard feet > 0 && feet <= 10 && inches > 0 && inches <= 12 else {
            throw MeasurementError.InvalidHeight
        }
        self.feet = feet
        self.inches = inches
    }
    
    class func parseClassName() -> String {
        return "Measurement"
    }
}

/**
 *  <#Description#>
 */
struct Disease {
    enum Disease: String {
        case Diabetes = "diabetes"
    }
    
    var disease: Disease
    var description: String {
        return disease.rawValue
    }
    
    init(withDiseaseName name: String) throws {
        guard let newDisease = Disease(rawValue: name) else {
            throw ConditionErrors.InvalidDisease
        }
        self.disease = newDisease
    }

}

struct Allergy {
    enum Allergies: String {
        case Insulin = "insulin"
    }
    
    var allergy: Allergies
    
    var description: String {
        return allergy.rawValue
    }
    
    init(withAllergyName name: String) throws {
        guard let newAllergy = Allergies(rawValue: name) else {
            throw ConditionErrors.InvalidAllergy
        }
        self.allergy = newAllergy
    }
}

struct Disorder {

    enum Disorders: String {
        case ExampleDisorder = "example"
    }
    
    var disorder: Disorders
    var description: String {
        return disorder.rawValue
    }
    
    init(withDisorderName name: String) throws {
        guard let newDisorder = Disorders(rawValue: name) else {
            throw ConditionErrors.InvalidDisorder
        }
        self.disorder = newDisorder
    }
}

struct CauseOfDeath {
    enum Cause: String {
        case HeartAttack = "heart attack"
    }
    
    var causeOfDeath: Cause
    var description: String {
        return causeOfDeath.rawValue
    }
    
    init(withCauseOfDeath cod: String) throws {
        guard let newCOD = Cause(rawValue: cod) else {
            throw ConditionErrors.InvalidCOD
        }
        self.causeOfDeath = newCOD
    }

}

enum ConditionErrors: ErrorType {
    case InvalidDisease
    case InvalidAllergy
    case InvalidCOD
    case InvalidDisorder
}

//MARK: Condition Class
/**
 A class that will contain all of the patient's conditions, including
 diseases, allergies, disorders, and, if applicable, the cause of death.
 *
 *  timeAdded: The time the /first/ condition of the patient was added
 *  timeUpdated: The time the condition's file was most recently updated
 *  disease: [String] -- any diseases the patient has been diagnosed with
 */
class Condition: PFObject, PFSubclassing {
    
    var timeAdded: NSDate? {
        return self.createdAt
    }
    
    var timeUpdated: NSDate? {
        return self.updatedAt
    }
    
    //The disease, allergies, and disorders arrays are all comprised of the rawValue description
    //of the corresponding struct (Disease, Disorder, Allergies, Cause of Death
    var disease: [String]? {
        get {
            return self["disease"] as? [String]
        }
        set {}
    }
    
    var allergies: [String]? {
        get {
            return self["allergies"] as? [String]
        }
        set {}
    }
    
    var disorders: [String]? {
        get {
            return self["disorders"] as? [String]
        }
        set {}
    }
    
    var causeOfDeath: String? {
        get {
            return self["causeOfDeath"] as? String
        }
        set {}
    }
    
    /**
     Method to add a new disease to the patient record
     
     - parameter newDisease: The new disease name
     
     - throws: An error if the disease name is invalid
     */
    func addDisease(newDisease: String) throws {
        do {
            let disease = try Disease(withDiseaseName: newDisease)
            self.disease?.append(disease.description)
        } catch ConditionErrors.InvalidDisease {
            throw ConditionErrors.InvalidDisease
        }
    }
    
    /**
     Method to add a new allergy to the patient's record
     
     - parameter newAllergy: The new allergy
     
     - throws: An error if the allergy name is invalid
     */
    func addAllergy(newAllergy: String) throws {
        do {
            let allergy = try Allergy(withAllergyName: newAllergy)
            self.allergies?.append(allergy.description)
        } catch ConditionErrors.InvalidAllergy {
            throw ConditionErrors.InvalidAllergy
        }
    }
    
    /**
     Method to add a new disorder to the patient's record
     
     - parameter newDisorder: The new disorder
     
     - throws: An error if the disorder name in invalid
     */
    func addDisorder(newDisorder: String) throws {
        do {
            let disorder = try Disorder(withDisorderName: newDisorder)
            self.disorders?.append(disorder.description)
        } catch ConditionErrors.InvalidDisorder {
            throw ConditionErrors.InvalidDisorder
        }
    }
    
    /**
     Method to add a new cause of death to the patient's record
     
     - parameter cause: The new cause of death
     
     - throws: An error if the ause of death is invalid
     */
    func addCauseOfDeath(cause: String) throws {
        do {
            let causeOfDeath = try CauseOfDeath(withCauseOfDeath: cause)
            self.causeOfDeath = causeOfDeath.description
        } catch ConditionErrors.InvalidCOD {
            throw ConditionErrors.InvalidCOD
        }
    }
    
    class func parseClassName() -> String {
        return "Condition"
    }
}


class Appointment: PFObject, PFSubclassing {
    
    var timeCreated: NSDate? {
        get { return self.createdAt }
    }
    
    var timeScheduled: NSDate? {
        get {
            return self["timeScheduled"] as? NSDate
        }
        set {
            if newValue != nil {
                self["timeScheduled"] = newValue!
            }
        }
    }
    
    var attendingPhysician: MIMSUser? {
        get {
            return self["doctor"] as? MIMSUser
        }
        set {
            if newValue != nil {
                self["doctor"] = newValue!
            }
        }
    }
    
    var department: Department? {
        get { return self["department"] as? Department }
        set { if newValue != nil { self["department"] = newValue! } }
    }
    
    var appointmentNotes: [String]? {
        get { return self["notes"] as? [String] }
        set {}
    }
    
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

    class func login(username: String, password: String, completion: (error: NSError?) ->()) throws {
        guard username.characters.count >= 6 else {
            throw ParseErrorCodes.InvalidUsernameLength(message: "You didn't enter enough characters for your username")
        }
        
        guard password.characters.count >= 8 else {
            throw ParseErrorCodes.InvalidPasswordLength(message: "You didn't enter enough characters for your password")
        }
        
        self.loginUser(username, password: password, completion: completion)

//        MIMSUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
//            if error == nil && user != nil {
//                completion(user: user! as? MIMSUser, error: nil)
//            } else {
//                completion(user: nil, error: error!)
//            }
//        }
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
            throw ParseErrorCodes.InvalidKey(message: "An invalid key/value was sent")
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
            throw ParseErrorCodes.InvalidKey(message: "An invalid key/value was sent")
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
        let query = PFQuery(className: "Patient Record")
        query.whereKey(key, equalTo: value)
        query.findObjectsInBackgroundWithBlock { (patientRecords, error) in
            if patientRecords != nil && error == nil {
                completion(patientRecords: patientRecords as? [PatientRecord], error: nil)
            } else {
                completion(patientRecords: nil, error: error!)
            }
        }
    }
}