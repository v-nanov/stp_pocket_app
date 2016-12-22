//
//  Model.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-12-22.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//

import Foundation

class Publication {
    let id: Int64?
    var acronym: String
    var title: String
    var version: String?
    var hasApp: Bool?
    var disabled: Bool?
    var categoryID: Int?
    var stateDifferenceID: Int?
    
    init(id: Int64) {
        self.id = id
        acronym = ""
        title = ""
        version = ""
    }
    
    init(id: Int64, acronym: String, title: String, version: String?, hasApp: Bool?, disabled: Bool?, categoryID: Int?, stateDifferenceID: Int?){
        self.id = id
        self.acronym = acronym
        self.title = title
        
        if let tmp = version {
            self.version = tmp
        }
        
        if let tmp = hasApp {
            self.hasApp = tmp
        }
        
        if let tmp = disabled {
            self.disabled = tmp
        }
        
        if let tmp = categoryID {
            self.categoryID = tmp
        }
        
        if let tmp = stateDifferenceID {
            self.stateDifferenceID = tmp
        }
    }
}

class Contact {
    let id: Int64?
    var name: String
    var phone: String
    var address: String
    
    init(id: Int64){
        self.id = id
        name = ""
        phone = ""
        address = ""
    }
    
    init(id: Int64, name: String, phone: String, address: String) {
        self.id = id
        self.name = name
        self.phone = phone
        self.address = address
    }
}
