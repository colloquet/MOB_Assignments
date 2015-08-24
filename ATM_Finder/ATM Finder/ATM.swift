//
//  ATM.swift
//  ATM Finder
//
//  Created by Colloque Tsui on 12/08/2015.
//  Copyright (c) 2015 Colloque Tsui. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

class ATM: NSObject, MKAnnotation {
    var bank:String
    var address:String
    var service:String
    var currency:String
    let coordinate:CLLocationCoordinate2D
    var distance:CLLocationDistance = CLLocationDistance()
    
    init(bank:String, address:String, service:String, currency:String ,coordinate:CLLocationCoordinate2D) {
        self.bank = bank
        self.address = address
        self.service = service
        self.currency = currency
        self.coordinate = coordinate
        
        super.init()
    }
    
    var title: String {
        return bank
    }
    
    var subtitle: String {
        return address
    }
}