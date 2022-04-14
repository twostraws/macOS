//
//  TimeZone-FormattedName.swift
//  TimeBuddy
//
//  Created by Paul Hudson on 14/04/2022.
//

import Foundation

extension TimeZone {
    var formattedName: String {
        let start = localizedName(for: .generic, locale: .current) ?? "Unknown"
        return "\(start) - \(identifier)"
    }
}
