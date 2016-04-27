//
//  MIMSTests.swift
//  MIMSTests
//
//  Created by Patrick M. Bush on 4/7/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import XCTest
@testable import MIMS

class MIMSTests: XCTestCase {
    
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
    
    func testTimeFromDate() {
        let date = NSDate()
        print(date.getTimeForAppointment())
    }
    
    func testDayFromDate() {
        let date = NSDate()
        print(date.getDateForAppointment())
    }
    
    func testAddAppointment() {
        let patient = Patient(withoutDataWithClassName: "Patient", objectId: "Xsl7iRq2jT")
        let department = try! Department(withName: "ENT")
        let appointment = Appointment(initWithDoctor: MIMSUser.currentUser()!, patient: patient, timeScheduled: NSDate(), department: department)
        try! appointment.save()
    }
    
}
