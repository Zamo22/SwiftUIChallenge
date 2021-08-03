//
//  ContentView.swift
//  Consolidation6
//
//  Created by Zaheer Moola on 2021/08/02.
//

import SwiftUI

struct ContentView: View {
    @State private var isImagePickerShown = false
    @State private var isImageNameSheetShown = false

    @State private var itemName = ""
    @State private var image: UIImage?

    @State private var items = [RememberItem]()
    let locationFetcher = LocationFetcher()

    var body: some View {
        NavigationView {
            List(items, id: \.self) { item in
                NavigationLink(destination: DetailView(image: item.image,
                                                       annotation: item.location)) {
                    HStack {
                        Image(uiImage: item.image)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .scaledToFit()
                        Text(item.name)
                    }
                }
            }
            .onAppear(perform: fetchItems)
            .navigationBarTitle("Remember this?")
            .navigationBarItems(trailing:
                                    Button("Add Item") {
                                        isImagePickerShown = true
                                    }
            )
            .sheet(isPresented: $isImagePickerShown, onDismiss: imageLoaded) {
                ImagePicker(image: $image)
            }
            .sheet(isPresented: $isImageNameSheetShown, onDismiss: nameAdded) {
                ImageNamer(name: $itemName)
            }
        }
    }

    private func imageLoaded() {
        isImageNameSheetShown = true
    }

    private func fetchItems() {
        locationFetcher.start()
        let fileName = FileManager.getDocumentsDirectory().appendingPathComponent("RememberedNames")
        do {
            let data = try Data(contentsOf: fileName)
            items = try JSONDecoder().decode([RememberItem].self, from: data)
        } catch let err {
            print("\(err) Unable to load saved data")
        }
    }

    private func nameAdded() {
        guard let image = image else { return }
        guard let currentLocation = locationFetcher.lastKnownLocation else {
            debugPrint("Unable to get image")
            return
        }
        let newLocation = CodableMKPointAnnotation()
        newLocation.title = itemName
        newLocation.coordinate = currentLocation

        items.append(RememberItem(name: itemName, image: image, location: newLocation))
        do {
            let fileName = FileManager.getDocumentsDirectory().appendingPathComponent("RememberedNames")
            let data = try JSONEncoder().encode(items)
            try data.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
        } catch let error {
            print("Unable to save data \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
