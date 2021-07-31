//
//  ContentView.swift
//  BucketList
//
//  Created by Zaheer Moola on 2021/07/27.
//

import SwiftUI
import LocalAuthentication
import MapKit

struct ContentView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?

    @State private var showingPlaceDetails = false
    @State private var showingAuthError = false
    @State private var showingEditScreen = false

    @State private var isUnlocked = false

    var body: some View {
        ZStack {
            if isUnlocked {
                AuthenticatedView(centerCoordinate: $centerCoordinate,
                                  locations: $locations,
                                  selectedPlace: $selectedPlace,
                                  showingAlert: $showingPlaceDetails,
                                  showingEditScreen: $showingEditScreen)
                    .alert(isPresented: $showingPlaceDetails) {
                        Alert(title: Text(selectedPlace?.title ?? "Unknown"),
                              message: Text(selectedPlace?.subtitle ?? "Missing place information"),
                              primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                                showingEditScreen = true
                              })
                    }
            } else {
                Button("Unlock places") {
                    authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .alert(isPresented: $showingAuthError) {
                    Alert(title: Text("Authentication error"),
                          message: Text("An error occured whilst authenticating you"),
                          dismissButton: .default(Text("Try again")))
                }
            }
        }
        .onAppear(perform: loadData)

        .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
            if selectedPlace != nil {
                EditView(placemark: selectedPlace!)
            }
        }
    }

    func loadData() {
        let fileName = FileManager.getDocumentsDirectory().appendingPathComponent("SavedPlaces")

        do {
            let data = try Data(contentsOf: fileName)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch let err {
            print("\(err) Unable to load saved data")
        }
    }

    func saveData() {
        do {
            let fileName = FileManager.getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(locations)
            try data.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }


    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                    } else {
                        showingAuthError = true
                    }
                }
            }
        } else {
            showingAuthError = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        let paths = self.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}
