//
//  FilterAndSortView.swift
//  SnowSeeker
//
//  Created by Zaheer Moola on 2021/08/17.
//

import SwiftUI

enum SortingOptions: String, CaseIterable, Equatable {
    case none = "Default"
    case alphabetical = "Alphabetical"
    case country = "Country"
}

struct FilterAndSortView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var resortModel: Resorts

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sort resorts by:")) {
                    Picker("Sort resorts", selection: $resortModel.sortOption) {
                        ForEach(SortingOptions.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }

                Section(header: Text("Filter")) {
                    Picker("Country", selection: $resortModel.countryFilter) {
                        ForEach(resortModel.allCountries, id: \.self) {
                            Text($0)
                        }
                    }

                    Picker("Price", selection: $resortModel.priceFilter) {
                        ForEach(resortModel.allPrices, id: \.self) {
                            Text($0)
                        }
                    }

                    Picker("Size", selection: $resortModel.sizeFilter)  {
                        ForEach(resortModel.allSizes, id: \.self) {
                            Text($0)
                        }
                    }
                }

            }
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
            })
        }
    }
}

struct FilterAndSortView_Previews: PreviewProvider {
    static var previews: some View {
        FilterAndSortView(resortModel: Resorts())
    }
}
