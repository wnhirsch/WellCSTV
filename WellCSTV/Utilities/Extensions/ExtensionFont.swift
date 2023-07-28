//
//  ExtensionFont.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 27/07/23.
//

import SwiftUI

extension Font {
    
    static func roboto(type: TextType = .body, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .black, .heavy:
            return .custom("Roboto-Black", size: type.textSize)
        case .bold, .semibold:
            return .custom("Roboto-Bold", size: type.textSize)
        case .ultraLight, .light:
            return .custom("Roboto-Light", size: type.textSize)
        case .medium:
            return .custom("Roboto-Medium", size: type.textSize)
        case .thin:
            return .custom("Roboto-Thin", size: type.textSize)
        default:
            return .custom("Roboto-Regular", size: type.textSize)
        }
    }
}
