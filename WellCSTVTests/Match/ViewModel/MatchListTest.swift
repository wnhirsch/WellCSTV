//
//  MatchListTest.swift
//  WellCSTVTests
//
//  Created by Wellington Nascente Hirsch on 28/07/23.
//

import XCTest
@testable import WellCSTV

@MainActor
class MatchListViewModelTests: XCTestCase {
    
    var worker: MatchMockWorker!
    var viewModel: MatchListViewModel!

    override func setUp() {
        super.setUp()
        worker = MatchMockWorker()
        viewModel = MatchListViewModel(worker: worker)
    }
    
    override func tearDown() {
        viewModel = nil
        worker = nil
        super.tearDown()
    }
    
    func testFetchMatches() {
        let mockMatchesPage1 = [
            MatchModel(id: 1, beginAt: .now, status: .running, league: nil, serie: nil, opponents: nil),
            MatchModel(id: 2, beginAt: .now, status: .canceled, league: nil, serie: nil, opponents: nil)
        ]
        worker.matches = mockMatchesPage1

        viewModel.fetchMatches()

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(worker.getMatchesByPageCalled, 1)
        XCTAssertEqual(worker.getMatchesByPagePage, 1)
        
        worker.successBlock?()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.matches.count, 2)
        XCTAssertEqual(viewModel.matches[0].id, 1)
        XCTAssertEqual(viewModel.matches[1].id, 2)
        
        // Page 2
        let mockMatchesPage2 = [
            MatchModel(id: 3, beginAt: .now, status: .canceled, league: nil, serie: nil, opponents: nil),
            MatchModel(id: 4, beginAt: .now, status: .finished, league: nil, serie: nil, opponents: nil)
        ]
        worker.matches = mockMatchesPage2

        viewModel.fetchMatches()
        
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(worker.getMatchesByPageCalled, 2)
        XCTAssertEqual(worker.getMatchesByPagePage, 2)
        
        worker.successBlock?()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.matches.count, 4)
        XCTAssertEqual(viewModel.matches[0].id, 1)
        XCTAssertEqual(viewModel.matches[1].id, 2)
        XCTAssertEqual(viewModel.matches[2].id, 3)
        XCTAssertEqual(viewModel.matches[3].id, 4)
    }

    func testRefreshMatches() {
        let mockMatches = [
            MatchModel(id: 1, beginAt: .now, status: .running, league: nil, serie: nil, opponents: nil),
            MatchModel(id: 2, beginAt: .now, status: .canceled, league: nil, serie: nil, opponents: nil)
        ]
        worker.matches = mockMatches

        viewModel.refreshMatches()
        
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(worker.getMatchesByPageCalled, 1)
        XCTAssertEqual(worker.getMatchesByPagePage, 1)
        
        worker.successBlock?()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.matches.count, 2)
        XCTAssertEqual(viewModel.matches[0].id, 1)
        XCTAssertEqual(viewModel.matches[1].id, 2)
    }

    func testFormatDate() {
        let today: Date = try! Date("2023-07-28T12:00:00Z", strategy: .iso8601)
        
        var thisWeek = today
        thisWeek.day -= 1
        
        var thisYear = today
        thisYear.month -= 2
        
        var otherYear = today
        otherYear.year -= 1

        XCTAssertEqual(viewModel.formatDate(nil), "")
        XCTAssertEqual(viewModel.formatDate(today), "Hoje, 09:00")
        XCTAssertEqual(viewModel.formatDate(thisWeek), "qui., 09:00")
        XCTAssertEqual(viewModel.formatDate(thisYear), "28.05 09:00")
        XCTAssertEqual(viewModel.formatDate(otherYear), "28.07.2022 09:00")
    }

    func testFormatTeamName() {
        XCTAssertEqual(viewModel.formatTeamName("Super Team", true), "Super Team")
        XCTAssertEqual(viewModel.formatTeamName("Ultra Team", false), "Ultra Team")
        XCTAssertEqual(viewModel.formatTeamName(nil, true), "Time 1")
        XCTAssertEqual(viewModel.formatTeamName(nil, false), "Time 2")
    }

    func testFormatLeagueAndSerie() {
        let league = LeagueModel(id: 1, name: "League 1", imageUrl: nil)
        let serie = SerieModel(id: 1, name: "Serie A")

        XCTAssertEqual(viewModel.formatLeagueAndSerie(nil, nil), "Liga + série")
        XCTAssertEqual(viewModel.formatLeagueAndSerie(league, nil), "League 1")
        XCTAssertEqual(viewModel.formatLeagueAndSerie(nil, serie), "Serie A")
        XCTAssertEqual(viewModel.formatLeagueAndSerie(league, serie), "League 1 + Serie A")
    }
}
