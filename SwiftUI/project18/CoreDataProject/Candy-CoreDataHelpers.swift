//
//  Candy-CoreDataHelpers.swift
//  CoreDataProject
//
//  Created by Paul Hudson on 21/05/2022.
//

import Foundation

extension Candy {
    var candyName: String {
        name ?? "Unknown Candy"
    }
}

extension Country {
    var countryShortName: String {
        shortName ?? "Unknown Country"
    }

    var countryFullName: String {
        fullName ?? "Unknown Country"
    }

    var countryCandy: [Candy] {
        let set = candy as? Set<Candy> ?? []
        return set.sorted {
            $0.candyName < $1.candyName
        }
    }
}
