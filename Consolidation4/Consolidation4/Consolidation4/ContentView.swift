//
//  ContentView.swift
//  Consolidation4
//
//  Created by Zaheer Moola on 2021/07/11.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var activities = Activities()

    @State private var addItemPresented = false

    var body: some View {
        NavigationView {
            List {
                ForEach(activities.items) { item in
                    NavigationLink(destination: ActivityDetailsView(activity: item, allActivites: activities)) {
                        HStack {
                            Text(item.title)
                                .font(.headline)
                            Spacer()
                            Text("\(item.completedCount)")
                        }
                    }
                }
            }
            .navigationBarTitle("My Activities")
            .navigationBarItems(leading:
                                    Button("Add Activity") {
                                        addItemPresented = true
                                    }
            )
        }
        .sheet(isPresented: $addItemPresented) {
            AddActivityView(activities: activities)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
