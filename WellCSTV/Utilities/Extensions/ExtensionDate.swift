//
//  ExtensionDate.swift
//  WellCSTV
//
//  Created by Wellington Nascente Hirsch on 28/07/23.
//

import SwiftUI

extension Date {
    
    // MARK: Components
    var components: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekOfYear], from: self)
    }
    var year: Int {
        components.year ?? .zero
    }
    var month: Int {
        components.month ?? .zero
    }
    var day: Int {
        components.day ?? .zero
    }
    var hour: Int {
        get {
            components.hour ?? .zero
        }
        set(hour) {
            var newComponents = components
            newComponents.hour = hour
            self = Calendar.current.date(from: newComponents) ?? self
        }
    }
    var minute: Int {
        get {
            components.minute ?? .zero
        }
        set(minute) {
            var newComponents = components
            newComponents.minute = minute
            self = Calendar.current.date(from: newComponents) ?? self
        }
    }
    var second: Int {
        get {
            components.second ?? .zero
        }
        set(second) {
            var newComponents = components
            newComponents.second = second
            self = Calendar.current.date(from: newComponents) ?? self
        }
    }
    var weekOfYear: Int {
        components.weekOfYear ?? .zero
    }

    // MARK: Methods
    /// Converts the date to any string formats
    func format(as format: String, style: DateFormatter.Style = .long) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
