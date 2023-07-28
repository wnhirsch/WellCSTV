//
//  MatchStatus.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 28/07/23.
//

import Foundation

enum MatchStatus: String, Decodable {
    case canceled
    case finished
    case notStarted = "not_started"
    case postponed
    case running
}
