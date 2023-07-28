//
//  PlayerModel.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 28/07/23.
//

import Foundation

struct PlayerModel: Decodable {
    let id: Int?
    let name: String?
    let firstName: String?
    let lastName: String?
    let imageUrl: String?
    let currentTeam: TeamModel?
}
