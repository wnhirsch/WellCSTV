//
//  MatchRepository.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 27/07/23.
//

import Foundation
import Moya

struct MatchRepository {

    enum Target: APITarget {
        case getMatchesByPage(fromDate: Date, toDate: Date, page: Int, pageSize: Int)

        var path: String {
            switch self {
            case let .getMatchesByPage(fromDate, toDate, page, pageSize):
                return "matches?sort=-begin_at"
                + "&range[begin_at]=\(fromDate.ISO8601Format()),\(toDate.ISO8601Format())"
                + "&page[size]=\(pageSize)&page[number]=\(page)"
            }
        }

        var method: Moya.Method {
            switch self {
            case .getMatchesByPage:
                return .get
            }
        }

        var task: Task {
            switch self {
            case .getMatchesByPage:
                return .requestPlain
            }
        }

        var headers: [String: String]? {
           return sessionHeader()
        }
    }

    private let provider: MoyaProvider<Target> = APIProvider<Target>().build()
}

extension MatchRepository {
    
    func getMatchesByPage(
        fromDate: Date,
        toDate: Date,
        page: Int,
        pageSize: Int,
        completion: @escaping Completion
    ) {
        provider.request(
            .getMatchesByPage(
                fromDate: fromDate,
                toDate: toDate,
                page: page,
                pageSize: pageSize
            ),
            completion: completion
        )
    }
}
