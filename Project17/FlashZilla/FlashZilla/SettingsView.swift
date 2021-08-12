//
//  SettingsView.swift
//  FlashZilla
//
//  Created by Zaheer Moola on 2021/08/12.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var requeueCards = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Card settings")) {
                    Toggle("Put incorrect cards back in pile", isOn: $requeueCards)
                        .onChange(of: requeueCards, perform: { _ in
                            saveData()
                        })
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
            .listStyle(GroupedListStyle())
            .onAppear(perform: loadData)
        }
    }

    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Settings") {
            if let decoded = try? JSONDecoder().decode(Bool.self, from: data) {
                self.requeueCards = decoded
            }
        }
    }

    func saveData() {
        if let data = try? JSONEncoder().encode(requeueCards) {
            UserDefaults.standard.set(data, forKey: "Settings")
        }
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
