//
//  PlayerRepository.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 28/07/23.
//

import Moya

struct PlayerRepository {

    enum Target: APITarget {
        case getPlayersByTeam(teamId: Int, page: Int, pageSize: Int)

        var path: String {
            switch self {
            case let .getPlayersByTeam(teamId, page, pageSize):
                return "players"
                + "?filter[team_id]=\(teamId)"
                + "&page[size]=\(pageSize)&page[number]=\(page)"
            }
        }

        var method: Moya.Method {
            switch self {
            case .getPlayersByTeam:
                return .get
            }
        }

        var task: Task {
            switch self {
            case .getPlayersByTeam:
                return .requestPlain
            }
        }

        var headers: [String: String]? {
           return sessionHeader()
        }
    }

    private let provider: MoyaProvider<Target> = APIProvider<Target>().build()
}

extension PlayerRepository {
    
    func getPlayersByTeam(teamId: Int, page: Int, pageSize: Int, completion: @escaping Completion) {
        provider.request(
            .getPlayersByTeam(teamId: teamId, page: page, pageSize: pageSize),
            completion: completion
        )
    }
}
