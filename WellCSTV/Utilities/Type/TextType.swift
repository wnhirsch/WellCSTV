//
//  TextType.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 27/07/23.
//

import Foundation

enum TextType: Int {
    
    /// size = 32pt
    case title
    /// size = 18pt
    case subTitle
    /// size = 14pt
    case header
    /// size = 12pt
    case body
    /// size = 10pt
    case caption
    /// size = 8pt
    case small
}

extension TextType {
    var textSize: CGFloat {
        switch self {
        case .title: return 32
        case .subTitle: return 18
        case .header: return 14
        case .body: return 12
        case .caption: return 10
        case .small: return 8
        }
    }
}
