//
//  DetailView.swift
//  Bookworm
//
//  Created by Paul Hudson on 21/05/2022.
//

import SwiftData
import SwiftUI

struct DetailView: View {
    @Bindable var review: Review

    @State private var showingRendered = false

    var body: some View {
        Form {
            TextField("Title", text: $review.title)
            TextField("Author", text: $review.author)

            Picker("Rating", selection: $review.rating) {
                ForEach(1..<6) {
                    Text(String($0))
//                        .tag($0)
                }
            }
            .pickerStyle(.segmented)

            TextEditor(text: $review.text)
        }
        .padding()
        .toolbar {
            Button("Show rendered", systemImage: "book") {
                showingRendered.toggle()
            }
        }
        .sheet(isPresented: $showingRendered) {
            RenderView(review: review)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Review.self, configurations: config)

        let review = Review(title: "Example title", author: "Example author", rating: 4, text: "Example review goes here", date: .now)

        return DetailView(review: review)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
