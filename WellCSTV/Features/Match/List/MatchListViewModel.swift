//
//  MatchListViewModel.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 27/07/23.
//

import Combine
import Foundation

@MainActor
class MatchListViewModel: ObservableObject {
    
    private let worker = MatchWorker()
    
    // MARK: View Attributes
    @Published var isLoading: Bool = false
    
    // MARK: Model Attributes
    @Published var matches: [MatchModel] = []
    private var page: Int = 1
    
    // MARK: Dynamic Attributes
    var isAtFirstPage: Bool {
        page == 1
    }
    
    // MARK: Methods
    func formatDate(_ date: Date?) -> String {
        guard let date else { return "" }
        
        if Calendar.current.isDateInToday(date) {
            return date.format(as: "match.list.date.today".localized)
        } else if date.weekOfYear == Date.now.weekOfYear && date.year == Date.now.year {
            return date.format(as: "match.list.date.thisWeek".localized)
        } else if date.year == Date.now.year {
            return date.format(as: "match.list.date.thisYear".localized)
        } else {
            return date.format(as: "match.list.date.default".localized)
        }
    }
    
    func formatTeamName(_ teamName: String?, _ isFirst: Bool) -> String {
        let placeholder = isFirst
            ? "match.list.team.first".localized
            : "match.list.team.second".localized
        return teamName ?? placeholder
    }
    
    func formatLeagueAndSerie(
        _ league: MatchModel.League?,
        _ serie: MatchModel.Serie?
    ) -> String {
        if let leagueName = league?.name, let serieName = serie?.name {
            return "\(leagueName) + \(serieName)"
        } else if let leagueName = league?.name {
            return leagueName
        } else if let serieName = serie?.name {
            return serieName
        } else {
            return "match.list.league.placeholder".localized
        }
    }
    
    // MARK: API
    func fetchMatches() {
        guard !isLoading else { return }
        isLoading.toggle()
        
        // Get final time of the day to get even the scheduled matches
        var today = Date.now
        today.hour = 23
        today.minute = 59
        today.second = 59
        
        worker.getMatchesByPage(toDate: today, page: page, success: { [weak self] matches in
            guard let self = self else { return }
            self.matches.append(contentsOf: matches)
            self.page += 1
            isLoading.toggle()
        }, failure: { })
    }
}
