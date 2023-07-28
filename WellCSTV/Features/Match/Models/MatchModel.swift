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
    let status: MatchStatus?
    let league: LeagueModel?
    let serie: SerieModel?
    let opponents: [Opponent]?

    struct Opponent: Decodable {
        let opponent: TeamModel?
    }
}
