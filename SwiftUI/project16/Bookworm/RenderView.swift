//
//  RenderView.swift
//  Bookworm
//
//  Created by Paul Hudson on 21/05/2022.
//

import SwiftUI

struct RenderView: View {
    let review: Review

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 10) {
            Text(review.reviewTitle)
                .font(.system(.largeTitle, design: .serif))

            Text("by \(review.reviewAuthor)")
                .font(.system(.title, design: .serif))
                .italic()

            HStack {
                ForEach(1..<6) { number in
                    Image(systemName: "star.fill")
                        .foregroundColor(number > review.rating ? .gray : .yellow)
                }
            }

            ScrollView {
                Text(review.reviewText)
                    .fontDesign(.serif)
                    .padding(.vertical)
            }

            Spacer()
                .frame(height: 50)

            Button("Done") {
                dismiss()
            }
        }
        .frame(maxWidth: 800)
        .padding(25)
    }
}

struct RenderView_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
        let review = Review(context: dataController.container.viewContext)

        RenderView(review: review)
    }
}
