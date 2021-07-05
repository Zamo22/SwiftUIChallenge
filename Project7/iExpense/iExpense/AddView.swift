//
//  AddView.swift
//  iExpense
//
//  Created by Zaheer Moola on 2021/07/04.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""

    @ObservedObject var expenses: Expenses
    @State private var isShowingInvalidAlert = false

    @Environment(\.presentationMode) var presentationMode

    static let types = ["Business", "Personal"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .alert(isPresented: $isShowingInvalidAlert) {
                Alert(title: Text("Invalid Expense"),
                      message: Text("The amount you entered is invalid"), dismissButton: .default(Text("Retry")))
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(
                trailing: Button("Save") {
                    if let actualAmount = Int(amount) {
                        let item = ExpenseItem(name: name, type: type, amount: actualAmount)
                        expenses.items.append(item)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        isShowingInvalidAlert = true
                    }
                }
            )
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
