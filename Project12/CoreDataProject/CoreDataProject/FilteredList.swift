//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Zaheer Moola on 2021/07/20.
//

import SwiftUI
import CoreData

enum FilterType: String {
    case beginsWith = "BEGINSWITH"
    case contains = "CONTAINS"
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var singers: FetchedResults<T> { fetchRequest.wrappedValue }

    // this is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content

    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { singer in
            self.content(singer)
        }
    }

    init(filterKey: String, filterValue: String, sortDescriptors: [NSSortDescriptor] = [], filterType: FilterType,
         @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: NSPredicate(format: "%K \(filterType.rawValue) %@", filterKey, filterValue))
        self.content = content
    }
}
