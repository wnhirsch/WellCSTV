//
//  TextModifier.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 27/07/23.
//

import SwiftUI

extension View {

    @ViewBuilder
    func cstvText(
        color: Color = .cstvText,
        type: TextType = .body,
        weight: Font.Weight = .regular,
        alignment: TextAlignment = .leading
    ) -> some View {
        self
            .foregroundColor(color)
            .font(.roboto(type: type, weight: weight))
            .multilineTextAlignment(alignment)
    }
}
