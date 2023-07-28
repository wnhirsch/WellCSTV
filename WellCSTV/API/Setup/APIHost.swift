//
//  APIHost.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 27/07/23.
//

import Foundation

enum APIHost {
    
    static var baseURL: URL {
        URL(string: "https://api.pandascore.co/csgo/")!
    }
    
    // It's not safe to put it hard coded, but for test purposes it's easier being right here
    static var accessToken: String = "Cm61BGQzysAEp-8LfsNGuISCKscvZXBieDoisJ2UCdDLQ3cDpd0"
    
    static var itemsPerPage: Int = 10
}
