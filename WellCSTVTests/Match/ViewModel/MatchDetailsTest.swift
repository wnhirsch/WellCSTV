//
//  MatchDetailsTest.swift
//  WellCSTVTests
//
//  Created by Wellington Nascente Hirsch on 28/07/23.
//

import XCTest
@testable import WellCSTV

@MainActor
class MatchDetailsTest: XCTestCase {
    
    var mockMatch: MatchModel!
    var worker: MatchMockWorker!
    var viewModel: MatchDetailsViewModel!
    
    override func setUp() {
        super.setUp()
        mockMatch = MatchModel(
            id: 1,
            beginAt: .now,
            status: .running,
            league: nil,
            serie: nil,
            opponents: [
                .init(opponent: TeamModel(id: 1, name: nil, imageUrl: nil)),
                .init(opponent: TeamModel(id: 2, name: nil, imageUrl: nil))
            ]
        )
        worker = MatchMockWorker()
        viewModel = MatchDetailsViewModel(match: mockMatch, worker: worker)
    }
    
    override func tearDown() {
        mockMatch = nil
        worker = nil
        viewModel = nil
        super.tearDown()
    }

    func testFetchFirstTeamPlayers() {
        let mockPlayers = [
            PlayerModel(
                id: 101,
                name: "playerone",
                firstName: "Player",
                lastName: "One",
                imageUrl: nil,
                currentTeam: nil
            ),
            PlayerModel(
                id: 102,
                name: "playertwo",
                firstName: "Player",
                lastName: "Two",
                imageUrl: nil,
                currentTeam: nil
            )
        ]
        worker.players = mockPlayers
        
        viewModel.fetchFirstTeamPlayers()

        XCTAssertEqual(worker.getPlayersByTeamCalled, 1)
        XCTAssertEqual(worker.getPlayersByTeamId, viewModel.firstTeam?.id)

        worker.successBlock?()

        XCTAssertEqual(viewModel.firstTeamPlayers.count, 2)
        XCTAssertEqual(viewModel.firstTeamPlayers[0].id, 101)
        XCTAssertEqual(viewModel.firstTeamPlayers[1].id, 102)
    }

    // Teste do Método fetchSecondTeamPlayers()
    func testFetchSecondTeamPlayers() {
        let mockPlayers = [
            PlayerModel(
                id: 103,
                name: "playerthree",
                firstName: "Player",
                lastName: "Three",
                imageUrl: nil,
                currentTeam: nil
            ),
            PlayerModel(
                id: 104,
                name: "playerfour",
                firstName: "Player",
                lastName: "Four",
                imageUrl: nil,
                currentTeam: nil
            )
        ]
        worker.players = mockPlayers
        
        viewModel.fetchSecondTeamPlayers()

        XCTAssertEqual(worker.getPlayersByTeamCalled, 1)
        XCTAssertEqual(worker.getPlayersByTeamId, viewModel.secondTeam?.id)

        worker.successBlock?()

        XCTAssertEqual(viewModel.secondTeamPlayers.count, 2)
        XCTAssertEqual(viewModel.secondTeamPlayers[0].id, 103)
        XCTAssertEqual(viewModel.secondTeamPlayers[1].id, 104)
    }

    // Teste das Funções de Formatação
    func testFormatTeamName() {
        XCTAssertEqual(viewModel.formatTeamName("Super Team", true), "Super Team")
        XCTAssertEqual(viewModel.formatTeamName("Ultra Team", false), "Ultra Team")
        XCTAssertEqual(viewModel.formatTeamName(nil, true), "Time 1")
        XCTAssertEqual(viewModel.formatTeamName(nil, false), "Time 2")
    }

    func testFormatPlayerFullname() {
        let playerWithFullName = PlayerModel(
            id: 1,
            name: nil,
            firstName: "Player",
            lastName: "One",
            imageUrl: nil,
            currentTeam: nil
        )
        let playerWithFirstName = PlayerModel(
            id: 2, name: nil,
            firstName: "Player",
            lastName: nil,
            imageUrl: nil,
            currentTeam: nil
        )
        let playerWithLastName = PlayerModel(
            id: 3, name: nil,
            firstName: nil,
            lastName: "Three",
            imageUrl: nil,
            currentTeam: nil
        )
        let playerWithoutName = PlayerModel(
            id: 4, name: nil,
            firstName: nil,
            lastName: nil,
            imageUrl: nil,
            currentTeam: nil
        )

        XCTAssertEqual(viewModel.formatPlayerFullname(playerWithFullName), "Player One")
        XCTAssertEqual(viewModel.formatPlayerFullname(playerWithFirstName), "Player")
        XCTAssertEqual(viewModel.formatPlayerFullname(playerWithLastName), "Three")
        XCTAssertEqual(viewModel.formatPlayerFullname(playerWithoutName), "")
    }

    func testFirstTeam() {
        XCTAssertEqual(viewModel.firstTeam?.id, mockMatch.opponents?.first?.opponent?.id)
    }

    func testSecondTeam() {
        XCTAssertEqual(viewModel.secondTeam?.id, mockMatch.opponents?.last?.opponent?.id)
    }

    func testFormattedDate() {
        let today: Date = try! Date("2023-07-28T12:00:00Z", strategy: .iso8601)
        
        var thisWeek = today
        thisWeek.day -= 1
        
        var thisYear = today
        thisYear.month -= 2
        
        var otherYear = today
        otherYear.year -= 1

        viewModel.match = MatchModel(id: nil, beginAt: nil, status: nil, league: nil, serie: nil, opponents: nil)
        XCTAssertEqual(viewModel.formattedDate, "")
        
        viewModel.match = MatchModel(id: nil, beginAt: today, status: nil, league: nil, serie: nil, opponents: nil)
        XCTAssertEqual(viewModel.formattedDate, "Hoje, 09:00")
        
        viewModel.match = MatchModel(id: nil, beginAt: thisWeek, status: nil, league: nil, serie: nil, opponents: nil)
        XCTAssertEqual(viewModel.formattedDate, "qui., 09:00")
        
        viewModel.match = MatchModel(id: nil, beginAt: thisYear, status: nil, league: nil, serie: nil, opponents: nil)
        XCTAssertEqual(viewModel.formattedDate, "28.05 09:00")
        
        viewModel.match = MatchModel(id: nil, beginAt: otherYear, status: nil, league: nil, serie: nil, opponents: nil)
        XCTAssertEqual(viewModel.formattedDate, "28.07.2022 09:00")
    }

    func testFormattedLeagueAndSerie() {
        let league = LeagueModel(id: 1, name: "League 1", imageUrl: nil)
        let serie = SerieModel(id: 1, name: "Serie A")

        viewModel.match = MatchModel(id: nil, beginAt: nil, status: nil, league: nil, serie: nil, opponents: nil)
        XCTAssertEqual(viewModel.formattedLeagueAndSerie, "Liga + série")
        
        viewModel.match = MatchModel(id: nil, beginAt: nil, status: nil, league: league, serie: nil, opponents: nil)
        XCTAssertEqual(viewModel.formattedLeagueAndSerie, "League 1")
        
        viewModel.match = MatchModel(id: nil, beginAt: nil, status: nil, league: nil, serie: serie, opponents: nil)
        XCTAssertEqual(viewModel.formattedLeagueAndSerie, "Serie A")
        
        viewModel.match = MatchModel(id: nil, beginAt: nil, status: nil, league: league, serie: serie, opponents: nil)
        XCTAssertEqual(viewModel.formattedLeagueAndSerie, "League 1 + Serie A")
    }
}
