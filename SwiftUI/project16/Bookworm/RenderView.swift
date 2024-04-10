//
//  RenderView.swift
//  Bookworm
//
//  Created by Paul Hudson on 21/05/2022.
//

import SwiftData
import SwiftUI

struct RenderView: View {
    let review: Review

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 10) {
            Text(review.title)
                .font(.system(.largeTitle, design: .serif))

            Text("by \(review.author)")
                .font(.system(.title, design: .serif))
                .italic()

            HStack {
                ForEach(1..<6) { number in
                    Image(systemName: "star.fill")
                        .foregroundStyle(number > review.rating ? .gray : .yellow)
                }
            }

            ScrollView {
                Text(review.text)
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

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Review.self, configurations: config)

        let review = Review(title: "Example title", author: "Example author", rating: 4, text: "Example review goes here", date: .now)

        return RenderView(review: review)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

