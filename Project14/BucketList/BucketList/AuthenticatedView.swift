//
//  AuthenticatedView.swift
//  BucketList
//
//  Created by Zaheer Moola on 2021/07/31.
//

import SwiftUI
import MapKit

struct AuthenticatedView: View {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var locations: [CodableMKPointAnnotation]
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingAlert: Bool
    @Binding var showingEditScreen: Bool

    var body: some View {
        MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace,
                showingPlaceDetails: $showingAlert, annotations: locations)
            .edgesIgnoringSafeArea(.all)
        Circle()
            .fill(Color.blue)
            .opacity(0.3)
            .frame(width: 32, height: 32)

        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    let newLocation = CodableMKPointAnnotation()
                    newLocation.title = "Example Location"
                    newLocation.coordinate = centerCoordinate
                    locations.append(newLocation)
                    selectedPlace = newLocation
                    showingEditScreen = true
                }) {
                    Image(systemName: "plus")
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                }

            }
        }
    }
}

//struct AuthenticatedView_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthenticatedView()
//    }
//}
