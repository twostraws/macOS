//
//  View-Snapshot.swift
//  Screenable
//
//  Created by Paul Hudson on 14/04/2022.
//

import SwiftUI

extension View {
    func snapshot() -> Data? {
        let view = NSHostingView(rootView: self)
        view.setFrameSize(view.fittingSize)

        guard let bitmapRep = view.bitmapImageRepForCachingDisplay(in: view.bounds) else { return nil }
        view.cacheDisplay(in: view.bounds, to: bitmapRep)

        return bitmapRep.representation(using: .png, properties: [:])
    }
}
