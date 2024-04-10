//
//  UsersView.swift
//  SwiftDataProject
//
//  Created by Paul Hudson on 10/04/2024.
//

import SwiftData
import SwiftUI

struct UsersView: View {
    @Query var users: [User]
    @Binding var selection: User?

    var body: some View {
        List(users, selection: $selection) { user in
            NavigationLink(value: user) {
                HStack {
                    Text(user.name)

                    Spacer()

                    Text(String(user.jobs?.count ?? 0))
                        .fontWeight(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(.capsule)
                }
            }
        }
    }

    init(selection: Binding<User?>, minimumJoinDate: Date = .now, sortOrder: [SortDescriptor<User>]) {
        _selection = selection

        _users = Query(filter: #Predicate<User> { user in
            user.joinDate >= minimumJoinDate
        }, sort: sortOrder)
    }
}

#Preview {
    UsersView(selection: .constant(nil), sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self)
}
