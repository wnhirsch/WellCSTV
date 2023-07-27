//
//  ExtensionImage.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 27/07/23.
//

import SwiftUI

extension Image {
    
    init(_ asset: AssetType) {
        self = Image(asset.rawValue)
    }
    
    func square(_ size: CGFloat) -> some View {
        return self
            .resizable()
            .frame(width: size, height: size)
    }
}
