//
//  ContentView.swift
//  Bookworm
//
//  Created by Paul Hudson on 21/05/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedReview: Review?

    var body: some View {
        NavigationSplitView {
            ListingView(selectedReview: $selectedReview)
                .frame(minWidth: 250)
        } detail: {
            if let selectedReview {
                DetailView(review: selectedReview)
            } else {
                Text("Please select a review")
            }
        }
    }
}

#Preview {
    ContentView()
}
