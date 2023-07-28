//
//  MatchListView.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 27/07/23.
//

import SwiftUI

struct MatchListView: View {
    
    @StateObject private var viewModel = MatchListViewModel()
    
    @State private var selectedId: Int?
    
    // MARK: Body
    var body: some View {
        VStack(spacing: .spacer24) {
            Text("match.list.title")
                .cstvText(type: .title, weight: .medium)
                .padding(.horizontal, .spacer24)
                .horizontalAlignment(.leading)
            
            matchList
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.cstvBackground)
        .onAppear {
            viewModel.fetchMatches()
        }
    }
}

extension MatchListView {
    
    // MARK: Match List
    private var matchList: some View {
        List {
            ForEach(viewModel.matches, id: \.id) { match in
                matchCard(match)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(
                        top: 0,
                        leading: .spacer24,
                        bottom: .spacer24,
                        trailing: .spacer24
                    ))
                    .onAppear {
                        if viewModel.matches.last?.id == match.id {
                            viewModel.fetchMatches()
                        }
                    }
                    .onTapGesture {
                        self.selectedId = match.id
                    }
                    .navigationDestination(isPresented: .init(
                        get: { selectedId == match.id }, // It will appear if this id is clicked
                        set: { _ in selectedId = nil }) // If dismiss, reset the state
                    ) { MatchDetailsView(match: match) }
            }
            if viewModel.isLoading && !viewModel.isAtFirstPage {
                ProgressView()
                    .controlSize(.large)
                    .tint(.cstvText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, .spacer24)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .overlay {
            if viewModel.isLoading && viewModel.isAtFirstPage {
                VStack {
                    Spacer()
                    
                    ProgressView()
                        .controlSize(.large)
                        .tint(.cstvText)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.cstvBackground)
            }
        }
        .tint(.cstvText)
        .refreshable {
            viewModel.refreshMatches()
        }
        .onAppear {
            UIRefreshControl.appearance().tintColor = .white
        }
    }
    
    // MARK: Match Card
    private func matchCard(_ match: MatchModel) -> some View {
        VStack(spacing: 0) {
            matchCardHeader(match.status, match.beginAt)
            
            HStack(spacing: .spacer20) {
                HStack {
                    Spacer()
                    
                    matchCardTeam(match.opponents?.first?.opponent, isFirst: true)
                }
                
                Text("match.list.versus")
                    .cstvText(color: .cstvText.opacity(0.5), type: .body)
                
                HStack {
                    matchCardTeam(match.opponents?.last?.opponent, isFirst: false)
                    
                    Spacer()
                }
            }
            .padding(.spacer20)
            
            matchCardFooter(match.league, match.serie)
        }
        .background(
            Color.cstvCard
                .clipped()
                .cornerRadius(.spacer16)
        )
    }
    
    // MARK: Match Card Header
    private func matchCardHeader(_ status: MatchStatus?, _ date: Date?) -> some View {
        HStack {
            Spacer()
            
            Text(status == .running ? "match.list.running".localized : viewModel.formatDate(date))
                .cstvText(type: .small, weight: .bold)
                .padding(.spacer8)
                .background(status == .running ? Color.cstvLive : Color.cstvInfo.opacity(0.2))
                .cornerRadius(.spacer16, corners: [.bottomLeft, .topRight])
                .opacity(date == nil ? 0 : 1)
        }
    }
    
    // MARK: Match Card Team
    private func matchCardTeam(_ team: TeamModel?, isFirst: Bool) -> some View {
        VStack(spacing: .spacer10) {
            AsyncImage(
                url: URL(string: team?.imageUrl ?? ""),
                transaction: .init(animation: .easeIn)
            ) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                default:
                    Circle().fill(Color.cstvProfile)
                }
            }
            .frame(width: .spacer60, height: .spacer60)
            
            Text(viewModel.formatTeamName(team?.name, isFirst))
                .cstvText(type: .caption)
                .lineLimit(1)
        }
    }
    
    // MARK: Match Card Footer
    private func matchCardFooter(_ league: LeagueModel?, _ serie: SerieModel?) -> some View {
        VStack(spacing: 0) {
            Divider()
                .overlay(Color.cstvText.opacity(0.2))
            
            HStack(spacing: .spacer8) {
                AsyncImage(
                    url: URL(string: league?.imageUrl ?? ""),
                    transaction: .init(animation: .easeIn)
                ) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                    default:
                        Circle().fill(Color.cstvCard)
                    }
                }
                .frame(width: .spacer16, height: .spacer16)
                
                Text(viewModel.formatLeagueAndSerie(league, serie))
                    .cstvText(type: .small)
            }
            .padding(.vertical, .spacer8)
            .padding(.horizontal, .spacer16)
            .horizontalAlignment(.leading)
        }
    }
    
}

// MARK: Preview
struct MatchListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MatchListView()
        }
    }
}
