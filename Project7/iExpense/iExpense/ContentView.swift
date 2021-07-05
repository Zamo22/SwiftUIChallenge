//
//  ContentView.swift
//  iExpense
//
//  Created by Zaheer Moola on 2021/07/03.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false

    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("$\(item.amount)")
                            .font(item.amount < 10 ? .title3 :
                                    item.amount < 100 ? .title2 : .title)
                            .foregroundColor(item.amount < 10 ? .green :
                                                item.amount < 100 ? .blue : .red)
                    }

                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(),
                                trailing: Button(action: {
                                showingAddExpense = true
                            }) {
                                Image(systemName: "plus")
                            }
                        )
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: expenses)
        }
    }

    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
