//
//  MatchMockWorker.swift
//  WellCSTVTests
//
//  Created by Wellington Nascente Hirsch on 28/07/23.
//

import Foundation

@testable import WellCSTV

class MatchMockWorker: MatchWorker {
    
    var getMatchesByPageCalled = 0
    var getMatchesByPagePage: Int?
    var matches: [MatchModel]?
    
    var getPlayersByTeamCalled = 0
    var getPlayersByTeamId: Int?
    var players: [PlayerModel]?
    
    var successBlock: (() -> Void)?
    
    override func getMatchesByPage(
        fromDate: Date = Date.distantPast,
        toDate: Date,
        page: Int,
        pageSize: Int = APIHost.defaultPageSize,
        success: (([MatchModel]) -> Void)? = nil,
        failure: (() -> Void)? = nil
    ) {
        getMatchesByPageCalled += 1
        getMatchesByPagePage = page

        successBlock = {
            if let matches = self.matches {
                success?(matches)
            } else {
                failure?()
            }
        }
    }
    
    override func getPlayersByTeam(
        teamId: Int,
        success: (([PlayerModel]) -> Void)? = nil,
        failure: (() -> Void)? = nil
    ) {
        getPlayersByTeamCalled += 1
        getPlayersByTeamId = teamId

        successBlock = {
            if let players = self.players {
                success?(players)
            } else {
                failure?()
            }
        }
    }
}
