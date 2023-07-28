//
//  PlayerRepository.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 28/07/23.
//

import Moya

struct PlayerRepository {

    enum Target: APITarget {
        case getPlayersByTeam(teamId: Int)

        var path: String {
            switch self {
            case let .getPlayersByTeam(teamId):
                return "players"
                + "?filter[team_id]=\(teamId)"
                + "&page[size]=\(10)&page[number]=\(1)"
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
    
    func getPlayersByTeam(teamId: Int, completion: @escaping Completion ) {
        provider.request(.getPlayersByTeam(teamId: teamId), completion: completion)
    }
}
