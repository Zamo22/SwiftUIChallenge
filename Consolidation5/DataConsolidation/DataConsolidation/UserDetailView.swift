//
//  UserDetailView.swift
//  DataConsolidation
//
//  Created by Zaheer Moola on 2021/07/23.
//

import SwiftUI

struct UserDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var user: User
    @FetchRequest(sortDescriptors: []) private var allUsers: FetchedResults<User>

    init(withUser user: User) {
        self.user = user
    }

    var body: some View {
        VStack(spacing: 15) {
            Text(user.wrappedName)
                .font(.largeTitle)

            Text("Age: \(user.age)")
                .foregroundColor(.gray)

            Text(user.wrappedEmail)
                .font(.body)

            Text(user.wrappedAddress)
                .font(.body)

            Text(user.wrappedAbout)
                .font(.body)
                .padding()

            List(user.friendsArray) { friend in
                NavigationLink(destination: UserDetailView(withUser: friendInfo(friend))) {
                    HStack {
                        Image("friend")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .scaledToFit()

                        Text(friend.wrappedName)
                            .font(.body)

                        Spacer()

                        Text("\(friendInfo(friend).age)")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
            }

            Spacer()
        }
    }

    func friendInfo(_ friend: Friend) -> User {
        allUsers.first(where: { $0.id == friend.id })!
    }
}

//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailView(withUser: Userm.defaultUser)
//    }
//}
