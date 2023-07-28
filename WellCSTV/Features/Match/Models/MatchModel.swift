//
//  MatchModel.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 27/07/23.
//

import Foundation

struct MatchModel: Decodable {
    let id: Int?
    let beginAt: Date?
    let status: Status?
    let league: League?
    let serie: Serie?
    let opponents: [Opponent]?
    
    enum Status: String, Decodable {
        case canceled
        case finished
        case notStarted = "not_started"
        case postponed
        case running
    }
    
    struct League: Decodable {
        let id: Int?
        let name: String?
        let imageUrl: String?
    }
    
    struct Serie: Decodable {
        let id: Int?
        let name: String?
    }
    
    struct Opponent: Decodable {
        let opponent: Team?
    }
    
    struct Team: Decodable {
        let id: Int?
        let name: String?
        let imageUrl: String?
    }
}
