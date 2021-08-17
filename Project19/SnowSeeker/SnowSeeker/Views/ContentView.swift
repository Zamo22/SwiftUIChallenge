//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Zaheer Moola on 2021/08/16.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var resorts = Resorts()
    @ObservedObject var favorites = Favorites()

    @State private var showFilterSheet = false

    var body: some View {
        NavigationView {
            List(resorts.filteredResorts) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1))

                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(1)

                    if favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .accessibility(label: Text("This is a favorite resort"))
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Resorts")
            .navigationBarItems(trailing: Button(action: {
                showFilterSheet = true
            }) {
                Image(systemName: "arrow.up.arrow.down.circle")
            })

            WelcomeView()
        }
        .environmentObject(favorites)
        .phoneOnlyStackNavigationView()
        .sheet(isPresented: $showFilterSheet, onDismiss: filterResorts) {
            FilterAndSortView(resortModel: resorts)
        }
    }

    private func filterResorts() {
        resorts.sortAndFilter()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}
