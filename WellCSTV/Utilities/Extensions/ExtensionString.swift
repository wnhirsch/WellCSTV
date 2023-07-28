//
//  ExtensionString.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 28/07/23.
//

import SwiftUI

extension String {
    
    /// Just calling this variable to any string you can obtain its localized version.
    /// Arguments can be applied using the same SwiftUI Text() format:
    ///     "key \(argument)".localized
    var localized: String {
        if let index = self.firstIndex(of: " ") {
            let key = self.prefix(upTo: index)
            let parameter = self.suffix(from: index)
            return String(format: NSLocalizedString("\(key) %@", comment: ""), String(parameter))
        } else {
            return String(localized: LocalizationValue(self))
        }
    }
}
