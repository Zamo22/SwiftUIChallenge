//
//  AddActivityView.swift
//  Consolidation4
//
//  Created by Zaheer Moola on 2021/07/11.
//

import SwiftUI

struct AddActivityView: View {
    @ObservedObject var activities: Activities

    @State private var title = ""
    @State private var description = ""

    @State private var isErrorAlertShown = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Activity Title")) {
                    TextField("Title", text: $title)
                }

                Section(header: Text("Activity Description")) {
                    TextField("Description", text: $description)
                }

                Button("Save") {
                    addNewItem()
                }
                .padding([.leading, .trailing])
            }
            .navigationBarTitle("Add new activity")
            .alert(isPresented: $isErrorAlertShown) {
                Alert(title: Text("Invalid data"),
                      message: Text("Please do not leave any fields empty"),
                      dismissButton: .default(Text("Try again")))
            }
        }
    }

    func addNewItem() {
        if !title.isEmpty && !description.isEmpty {
            let newItem = ActivityItem(title: title, details: description, completedCount: 0)
            activities.items.append(newItem)
            presentationMode.wrappedValue.dismiss()
        } else {
            isErrorAlertShown = true
        }
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView(activities: Activities())
    }
}
