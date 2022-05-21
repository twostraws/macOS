//
//  ContentView.swift
//  Bookworm
//
//  Created by Paul Hudson on 21/05/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ListingView()
                .frame(minWidth: 250)

            Text("Please select a review")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
