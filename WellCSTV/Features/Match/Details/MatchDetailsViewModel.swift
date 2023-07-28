//
//  MatchDetailsViewModel.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 28/07/23.
//

import Combine
import Foundation

@MainActor
class MatchDetailsViewModel: ObservableObject {
    
    private let worker = MatchWorker()
    
    // MARK: View Attributes
    @Published var isLoading: Bool = false
    @Published private var isLoadingFirst: Bool = false
    @Published private var isLoadingSecond: Bool = false
    
    // MARK: Model Attributes
    @Published var match: MatchModel
    @Published var firstTeamPlayers: [PlayerModel] = []
    @Published var secondTeamPlayers: [PlayerModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Dynamic Attributes
    var firstTeam: TeamModel? {
        match.opponents?.first?.opponent
    }
    
    var secondTeam: TeamModel? {
        match.opponents?.last?.opponent
    }
    
    var formattedDate: String {
        guard let date = match.beginAt else { return "" }
        
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
    
    var formattedLeagueAndSerie: String {
        if let leagueName = match.league?.name, let serieName = match.serie?.name {
            return "\(leagueName) + \(serieName)"
        } else if let leagueName = match.league?.name {
            return leagueName
        } else if let serieName = match.serie?.name {
            return serieName
        } else {
            return "match.list.league.placeholder".localized
        }
    }
    
    // MARK: Init
    init(match: MatchModel) {
        self.match = match
    }
    
    // MARK: Methods
    func setupBinding() {
        $isLoadingFirst.combineLatest($isLoadingSecond)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] first, second in
                guard let self else { return }
                self.isLoading = first || second
        }.store(in: &cancellables)
    }
    
    func destroyBinding() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func formatTeamName(_ teamName: String?, _ isFirst: Bool) -> String {
        let placeholder = isFirst
            ? "match.list.team.first".localized
            : "match.list.team.second".localized
        return teamName ?? placeholder
    }
    
    func formatPlayerFullname(_ player: PlayerModel) -> String {
        if let firstName = player.firstName, let lastName = player.lastName {
            return "\(firstName) \(lastName)"
        } else if let firstName = player.firstName {
            return firstName
        } else if let lastName = player.lastName {
            return lastName
        } else {
            return ""
        }
    }
    
    // MARK: API
    func fetchFirstTeamPlayers() {
        guard !isLoadingFirst, let id = firstTeam?.id else { return }
        isLoadingFirst.toggle()
        
        worker.getPlayersByTeam(teamId: id, success: { [weak self] players in
            guard let self = self else { return }
            self.firstTeamPlayers = players
            isLoadingFirst.toggle()
        }, failure: { })
    }
    
    func fetchSecondTeamPlayers() {
        guard !isLoadingSecond, let id = secondTeam?.id else { return }
        isLoadingSecond.toggle()
        
        worker.getPlayersByTeam(teamId: id, success: { [weak self] players in
            guard let self = self else { return }
            self.secondTeamPlayers = players
            isLoadingSecond.toggle()
        }, failure: { })
    }
}
