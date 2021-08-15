//
//  ContentView.swift
//  FinalChallenge
//
//  Created by Zaheer Moola on 2021/08/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RollerView()
                .tabItem {
                    Text("Roll")
                    Image(systemName: "octagon.fill")
                }

            RollsView()
                .tabItem {
                    Text("Previous Rolls")
                    Image(systemName: "list.bullet")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
