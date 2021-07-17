//
//  DetailView.swift
//  Bookworm
//
//  Created by Zaheer Moola on 2021/07/17.
//

import SwiftUI
import CoreData

struct DetailView: View {
    let book: Book

    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var showingDeleteAlert = false

    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(book.genre ?? "Fantasy")
                        .frame(maxWidth: geo.size.width)

                    Text(book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }

                Text(book.author ?? "Unknown Author")
                    .font(.title)
                    .foregroundColor(.secondary)

                Text(book.review ?? "No review")
                    .padding()

                Text("Date read: \(formattedDate)")

                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)

                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: { showingDeleteAlert = true }) {
            Image(systemName: "trash")
        }
        )
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"),
                  message: Text("Are you sure?"),
                  primaryButton: .destructive(Text("Delete"), action: deleteBook),
                  secondaryButton: .cancel())
        }
    }

    func deleteBook() {
        viewContext.delete(book)

        try? viewContext.save()
        presentationMode.wrappedValue.dismiss()
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: book.date ?? Date())
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."

        return NavigationView {
            DetailView(book: book)
        }
    }
}
