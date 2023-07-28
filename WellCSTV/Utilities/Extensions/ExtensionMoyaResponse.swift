//
//  ExtensionMoyaResponse.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 27/07/23.
//

import Foundation
import Moya

extension Moya.Response {

    func mapObject<T: Decodable>(_ type: T.Type) throws -> T {
        let formatter = DateFormatter()
        formatter.timeZone = .gmt
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return try map(type, using: decoder)
    }
}
