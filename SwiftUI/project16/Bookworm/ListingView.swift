//
//  ListingView.swift
//  Bookworm
//
//  Created by Paul Hudson on 21/05/2022.
//

import SwiftUI

struct ListingView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(sortDescriptors: [SortDescriptor(\.id)]) var reviews: FetchedResults<Review>
    @AppStorage("id") var id = 1

    var body: some View {
        List(reviews, selection: $dataController.selectedReview) { review in
            Text(review.reviewTitle)
                .tag(review)
                .contextMenu {
                    Button("Delete", role: .destructive, action: deleteSelected)
                }
        }
        .toolbar {
            Button(action: addReview) {
                Label("Add Review", systemImage: "plus")
            }

            Button(action: deleteSelected) {
                Label("Delete", systemImage: "trash")
            }
            .disabled(dataController.selectedReview == nil)
        }
        .onDeleteCommand(perform: deleteSelected)
    }

    func addReview() {
        let review = Review(context: managedObjectContext)
        review.id = Int32(id)
        review.title = "Enter the title"
        review.author = "Enter the author"
        review.rating = 3

        id += 1

        dataController.save()
        dataController.selectedReview = review
    }

    func deleteSelected() {
        guard let selectedReview = dataController.selectedReview else {
            return
        }

        guard let selectedIndex = reviews.firstIndex(of: selectedReview) else {
            return
        }

        managedObjectContext.delete(selectedReview)
        dataController.save()

        if selectedIndex < reviews.count {
            dataController.selectedReview = reviews[selectedIndex]
        } else {
            let previousIndex = selectedIndex - 1

            if previousIndex >= 0 {
                dataController.selectedReview = reviews[previousIndex]
            }
        }
    }
}

struct ListingView_Previews: PreviewProvider {
    static var previews: some View {
        ListingView()
    }
}
