//
//  ContentView.swift
//  DataConsolidation
//
//  Created by Zaheer Moola on 2021/07/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [])
    private var users: FetchedResults<User>

//    @State private var users = [User]()

    var body: some View {
        NavigationView {
            List(users) { user in
                NavigationLink(destination: UserDetailView(withUser: user)) {
                    HStack {
                        Text(user.wrappedName)
                            .font(.headline)
                        Spacer()
                        Text("\(user.age)")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationBarTitle("Users")
            .onAppear(perform: fetchUsers)
        }
    }

    func fetchUsers() {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let users = try? JSONDecoder().decode([UserModel].self, from: data) else { return }
            for user in users {
                for friend in user.friends {
                    let friend1 = Friend(context: viewContext)
                    friend1.id = friend.id
                    friend1.name = friend.name
                    friend1.origin = User(context: viewContext)
                    friend1.origin?.id = user.id
                    friend1.origin?.name = user.name
                    friend1.origin?.age = Int16(user.age)
                    friend1.origin?.about = user.about
                    friend1.origin?.address = user.address
                    friend1.origin?.emall = user.email
                }
            }

            DispatchQueue.main.async {
                try? viewContext.save()
            }

        }.resume()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
