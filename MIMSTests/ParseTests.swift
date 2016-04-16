//
//  ParseTests.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/15/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import XCTest
import Parse
@testable import MIMS


class ParseTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}

class ParseTreatmentTests: XCTestCase {
    var user: MIMSUser!
    var patient: Patient!
    var patientRecord: PatientRecord!
    
    override func setUp() {
        super.setUp()
        user = MIMSUser.currentUser()!
//        patient = Patient()
//        patient.name = "Patrick"
//        patientRecord = PatientRecord()
//        patientRecord.patient = patient
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddTreatment() {
        print(user)
        let treatment = Prescription()
        treatment.pharmacist = user
//        self.patientRecord.treatments?.append(treatment)
//        try! patientRecord.save()
        try! treatment.save()
        print(treatment.pharmacist)
        print(user)
        XCTAssert(treatment.pharmacist == user)
        
    }
    
    
}
