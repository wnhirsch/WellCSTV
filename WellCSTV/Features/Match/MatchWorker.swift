//
//  MatchWorker.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 27/07/23.
//

import Foundation

class MatchWorker {
    
    private let matchAPI: MatchRepository
    private let playerAPI: PlayerRepository
    
    init(matchAPI: MatchRepository = .init(), playerAPI: PlayerRepository = .init()) {
        self.matchAPI = matchAPI
        self.playerAPI = playerAPI
    }
    
    func getMatchesByPage(
        fromDate: Date = Date.distantPast,
        toDate: Date,
        page: Int,
        pageSize: Int = APIHost.defaultPageSize,
        success: (([MatchModel]) -> Void)? = nil,
        failure: (() -> Void)? = nil
    ) {
        matchAPI.getMatchesByPage(
            fromDate: fromDate,
            toDate: toDate,
            page: page,
            pageSize: pageSize
        ) { result in
            switch result {
            case let .success(response):
                do {
                    let matches = try response.mapObject([MatchModel].self)
                    success?(matches)
                } catch let error {
                    print(error)
                    failure?()
                }
            case let .failure(error):
                print(error)
                failure?()
            }
        }
    }
    
    func getPlayersByTeam(
        teamId: Int,
        success: (([PlayerModel]) -> Void)? = nil,
        failure: (() -> Void)? = nil
    ) {
        // Using the maximum page size because, at this context, it will always have less than 100 players in a team
        playerAPI.getPlayersByTeam(teamId: teamId, page: 1, pageSize: APIHost.maxPageSize) { result in
            switch result {
            case let .success(response):
                do {
                    let players = try response.mapObject([PlayerModel].self)
                    success?(players)
                } catch let error {
                    print(error)
                    failure?()
                }
            case let .failure(error):
                print(error)
                failure?()
            }
        }
    }
}
