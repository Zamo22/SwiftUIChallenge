//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Zaheer Moola on 2021/08/16.
//

import SwiftUI

struct ResortView: View {
    @Environment(\.horizontalSizeClass) var sizeClass

    @State private var selectedFacility: Facility?

    @EnvironmentObject var favorites: Favorites

    let resort: Resort

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    Image(decorative: resort.id)
                        .resizable()
                        .scaledToFit()

                    ZStack {
                        Text("Credit: \(resort.imageCredit)")
                            .font(.caption)
                            .padding(5)
                            .foregroundColor(.white)
                    }.background(Color.black)
                    .opacity(0.8)
                    .cornerRadius(10.0)
                    .padding(6)
                }

                HStack {
                    if sizeClass == .compact {
                        Spacer()
                        VStack { ResortDetailsView(resort: resort) }
                        VStack { SkiDetailsView(resort: resort) }
                        Spacer()
                    } else {
                        ResortDetailsView(resort: resort)
                        Spacer().frame(height: 0)
                        SkiDetailsView(resort: resort)
                    }
                }
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)

                Group {
                    Text(resort.description)
                        .padding(.vertical)

                    Text("Facilities")
                        .font(.headline)

                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            facility.icon
                                .font(.title)
                                .onTapGesture {
                                    self.selectedFacility = facility
                                }
                        }
                    }
                        .padding(.vertical)
                }
                .padding(.horizontal)
            }

            Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                favorites.contains(self.resort) ? favorites.remove(resort) : favorites.add(resort)
            }
            .padding()
        }
        .navigationBarTitle(Text("\(resort.name), \(resort.country)"), displayMode: .inline)
        .alert(item: $selectedFacility) { facility in
            facility.alert
        }
    }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        ResortView(resort: Resort.example)
    }
}
