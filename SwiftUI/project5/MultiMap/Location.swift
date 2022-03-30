//
//  Location.swift
//  MultiMap
//
//  Created by Paul Hudson on 30/03/2022.
//

import MapKit

struct Location: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
