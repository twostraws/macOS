//
//  DetailView.swift
//  Bookworm
//
//  Created by Paul Hudson on 21/05/2022.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var review: Review

    @State private var showingRendered = false

    var body: some View {
        Form {
            TextField("Title", text: $review.reviewTitle)
            TextField("Author", text: $review.reviewAuthor)

            Picker("Rating", selection: $review.rating) {
                ForEach(1..<6) {
                    Text(String($0))
                        .tag(Int32($0))
                }
            }
            .pickerStyle(.segmented)

            TextEditor(text: $review.reviewText)
        }
        .padding()
        .toolbar {
            Button {
                showingRendered.toggle()
            } label: {
                Label("Show rendered", systemImage: "book")
            }
        }
        .sheet(isPresented: $showingRendered) {
            RenderView(review: review)
        }
        .onChange(of: review.reviewTitle, perform: dataController.enqueueSave)
        .onChange(of: review.reviewAuthor, perform: dataController.enqueueSave)
        .onChange(of: review.reviewText, perform: dataController.enqueueSave)
        .onChange(of: review.rating, perform: dataController.enqueueSave)
        .disabled(review.managedObjectContext == nil)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
        let review = Review(context: dataController.container.viewContext)

        DetailView(review: review)
            .environmentObject(dataController)
    }
}
