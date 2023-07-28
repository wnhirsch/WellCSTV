//
//  MatchDetailsView.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 28/07/23.
//

import SwiftUI

struct MatchDetailsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: MatchDetailsViewModel
    
    init(match: MatchModel) {
        self._viewModel = StateObject(wrappedValue: .init(match: match))
    }
    
    // MARK: Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .spacer20) {
                teamList
                
                Text(viewModel.formattedDate)
                    .cstvText(type: .body, weight: .bold)
                
                playerList
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.cstvBackground)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(.back)
                    .renderingMode(.template)
                    .square(.spacer24)
                    .foregroundColor(.cstvText)
                    .onTapGesture {
                        dismiss()
                    }
            }
            ToolbarItem(placement: .principal) {
                Text(viewModel.formattedLeagueAndSerie)
                    .cstvText(type: .subTitle, weight: .medium)
            }
        }
        .toolbarBackground(Color.cstvBackground, for: .navigationBar)
        .overlay {
            if viewModel.isLoading {
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.setupBinding()
            viewModel.fetchFirstTeamPlayers()
            viewModel.fetchSecondTeamPlayers()
        }
        .onDisappear {
            viewModel.destroyBinding()
        }
    }
}

extension MatchDetailsView {
    
    // MARK: Team List
    private var teamList: some View {
        HStack(spacing: .spacer20) {
            HStack {
                Spacer()
                
                teamRow(viewModel.firstTeam, isFirst: true)
            }
            
            Text("match.list.versus")
                .cstvText(color: .cstvText.opacity(0.5), type: .body)
            
            HStack {
                teamRow(viewModel.secondTeam, isFirst: false)
                
                Spacer()
            }
        }
        .padding(.spacer20)
    }
    
    // MARK: Team Row
    private func teamRow(_ team: TeamModel?, isFirst: Bool) -> some View {
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
    
    // MARK: Player List
    private var playerList: some View {
        HStack(spacing: .spacer12) {
            VStack(spacing: .spacer12) {
                // Ensure that if this list is empty, it not affects the other list width
                Divider().hidden()
                
                ForEach(viewModel.firstTeamPlayers, id: \.id) { player in
                    playerRow(player, isFirst: true)
                }
            }
            
            VStack(spacing: .spacer12) {
                // Ensure that if this list is empty, it not affects the other list width
                Divider().hidden()
                
                ForEach(viewModel.secondTeamPlayers, id: \.id) { player in
                    playerRow(player, isFirst: false)
                }
            }
        }
        .padding(.bottom, .spacer20)
    }
    
    // MARK: Player Row
    private func playerRow(_ player: PlayerModel, isFirst: Bool) -> some View {
        HStack(alignment: .bottom, spacing: .spacer16) {
            VStack(alignment: .trailing) {
                Text(player.name ?? "")
                    .cstvText(type: .header, weight: .bold)
                    .lineLimit(1)
                
                Text(viewModel.formatPlayerFullname(player))
                    .cstvText(color: .cstvSubtext, type: .body)
                    .lineLimit(1)
            }
            
            AsyncImage(
                url: URL(string: player.imageUrl ?? ""),
                transaction: .init(animation: .easeIn)
            ) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(.spacer8)
                default:
                    RoundedRectangle(cornerRadius: .spacer8)
                        .fill(Color.cstvProfile)
                }
            }
            .frame(width: .spacer48, height: .spacer48)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.leading, .spacer8)
        .padding(.bottom, .spacer8)
        .padding(.trailing, .spacer12)
        .background {
            RoundedCorner(
                radius: .spacer12,
                corners: isFirst ? [.bottomRight, .topRight] : [.bottomLeft, .topLeft])
                .fill(Color.cstvCard)
                .padding(.top, .spacer4)
        }
        .environment(\.layoutDirection, isFirst ? .leftToRight : .rightToLeft)
    }
}

// MARK: Preview
struct MatchDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MatchDetailsView(match: .init(
                id: 0,
                beginAt: .now,
                status: .finished,
                league: .init(id: 0, name: "Master League", imageUrl: ""),
                serie: .init(id: 0, name: "Final series"),
                opponents: [
                    .init(opponent: .init(id: 0, name: "Team A", imageUrl: "")),
                    .init(opponent: .init(id: 1, name: "Team B", imageUrl: ""))
                ]
            ))
        }
    }
}
