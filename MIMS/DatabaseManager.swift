//
//  DatabaseManager.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/7/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import Foundation
import SQLite.Swift

enum DatabaseError : ErrorType {
    case BadConnection(message: String)
    case NoResult(message: String)
}



class User {
    let id: Expression<Int64>!
    let email: Expression<String>!
    let name: Expression<String>!
    
    init() {
        id = Expression<Int64>("id")
        email = Expression<String>("email")
        name = Expression<String>("name")
        
    }
}


class DBManager {
    
    let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
    let userTable:Table!
    var database: Connection!
    
    
    init() throws {
        do {
            database = try Connection("\(path)/db.sqlite3")
            userTable = Table("users")
        } catch let error as NSError {
            throw DatabaseError.BadConnection(message: error.localizedDescription)
        }
    }
    
    func createTable() throws {
        let user = User()
        try database.run(userTable.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
            t.column(user.id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
            t.column(user.email, unique: true)  //     "email" TEXT UNIQUE NOT NULL,
            t.column(user.name)                 //     "name" TEXT
            })
    }
}