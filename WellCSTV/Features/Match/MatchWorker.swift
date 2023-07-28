//
//  MatchWorker.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 27/07/23.
//

import Foundation

class MatchWorker {
    
    private let api: MatchRepository
    
    init(api: MatchRepository = .init()) {
        self.api = api
    }
    
    func getMatchesByPage(
        fromDate: Date = Date.distantPast,
        toDate: Date,
        page: Int,
        pageSize: Int = APIHost.itemsPerPage,
        success: (([MatchModel]) -> Void)? = nil,
        failure: (() -> Void)? = nil
    ) {
        api.getMatchesByPage(
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
}
