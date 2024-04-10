//
//  ListingView.swift
//  Bookworm
//
//  Created by Paul Hudson on 21/05/2022.
//

import SwiftData
import SwiftUI

struct ListingView: View {
    @Binding var selectedReview: Review?
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Review.date) var reviews: [Review]

    var body: some View {
        List(reviews, selection: $selectedReview) { review in
            Text(review.title)
                .tag(review)
                .contextMenu {
                    Button("Delete", role: .destructive, action: deleteSelected)
                }
        }
        .toolbar {
            Button("Add Review", systemImage: "plus", action: addReview)

            Button("Delete", systemImage: "trash", action: deleteSelected)
                .disabled(selectedReview == nil)
        }
    }

    func addReview() {
        let review = Review(title: "Enter the title", author: "Enter the author", rating: 3, text: "", date: .now)
        modelContext.insert(review)
        selectedReview = review
    }

    func deleteSelected() {
        guard let selected = selectedReview else {
            return
        }

        guard let selectedIndex = reviews.firstIndex(of: selected) else {
            return
        }

        modelContext.delete(selected)
        try? modelContext.save()

        if selectedIndex < reviews.count - 1 {
            selectedReview = reviews[selectedIndex]
        } else {
            let previousIndex = selectedIndex

            if previousIndex >= 0 {
                selectedReview = reviews[previousIndex]
            }
        }
    }
}

#Preview {
    ListingView(selectedReview: .constant(nil))
}
