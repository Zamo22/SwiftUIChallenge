//
//  Resort.swift
//  SnowSeeker
//
//  Created by Zaheer Moola on 2021/08/16.
//

import Foundation

enum Sizes: Int {
    case small = 1
    case medium = 2
    case large = 3

    var text: String {
        switch self {
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        }
    }

    init?(string: String) {
        switch string {
        case "Small":
            self = .small
        case "Medium":
            self = .medium
        default:
            self = .large
        }
    }
}

class Resorts: ObservableObject {
    private let resorts: [Resort] = Bundle.main.decode("resorts.json")

    var allCountries: [String] {
        var countries = resorts.map { $0.country }.uniqued()
        countries.insert("None", at: 0)
        return countries
    }

    var allPrices: [String] {
        var prices = resorts.map { $0.price }.uniqued().map({ String(repeating: "$", count: $0) })
        prices.insert("None", at: 0)
        return prices
    }

    var allSizes: [String] {
        var sizes = resorts.map { $0.size }.uniqued().compactMap { Sizes(rawValue: $0)?.text }
        sizes.insert("None", at: 0)
        return sizes
    }

    @Published var sortOption = SortingOptions.none

    @Published var countryFilter = "None"
    @Published var priceFilter = "None"
    @Published var sizeFilter = "None"

    @Published var filteredResorts: [Resort] = Bundle.main.decode("resorts.json")

    func sortAndFilter() {
        //change
        var filteredItems = resorts
        if countryFilter != "None" {
            filteredItems = filteredItems.filter { $0.country == countryFilter }
        }
        if priceFilter != "None" {
            filteredItems = filteredItems.filter { $0.price == priceFilter.count }
        }
        if sizeFilter != "None" {
            let actualSizeFilter = Sizes(string: sizeFilter)
            filteredItems = filteredItems.filter { $0.size == actualSizeFilter?.rawValue }
        }

        switch sortOption {
        case .alphabetical:
            filteredResorts = filteredItems.sorted(by: { $0.name < $1.name })
        case .country:
            filteredResorts = filteredItems.sorted(by: { $0.country < $1.country })
        default:
            filteredResorts = filteredItems
        }

    }
}

struct Resort: Codable, Identifiable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]

    var facilityTypes: [Facility] {
        facilities.map(Facility.init)
    }

    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts[0]
}
