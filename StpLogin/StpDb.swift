//
//  StpDb.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-12-21.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//

import SQLite

class StpDB {
    
    static let instance = StpDB()
    private let db: Connection?
    
    private let contacts = Table("contacts")
    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let phone = Expression<String>("phone")
    private let address = Expression<String>("address")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/Stp.sqlite3")
        } catch {
            db = nil
            print("Unable to open database.")
        }
        
        createTable()
        
    }
    
    func createTable() {
        do {
            try db!.run(contacts.create(ifNotExists: true) { table in
                    table.column(id, primaryKey: true)
                    table.column(name)
                    table.column(phone, unique: true)
                    table.column(address)
            })
        } catch {
          print("Unable to create table")
        }
    }
    
    func addContact(cname: String, cphone: String, caddress: String) -> Int64? {
        do {
            let insert = contacts.insert(name <- cname, phone <- cphone, address <- caddress)
            let id = try db!.run(insert)
            
            return id
            
        } catch {
            return -1
        }
    }
    
    func getContacts() -> [Contact] {
        var contacts = [Contact]()
        
        do {
            for contact in try db!.prepare(self.contacts){
                contacts.append(Contact(
                    id: contact[id],
                    name: contact[name],
                    phone: contact[phone],
                    address: contact[address]))
            }
        } catch {
            print("Select failed")
        }
        
        return contacts
    }
}

