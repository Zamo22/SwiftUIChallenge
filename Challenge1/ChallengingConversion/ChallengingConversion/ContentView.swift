//
//  ContentView.swift
//  ChallengingConversion
//
//  Created by Zaheer Moola on 2021/06/23.
//

import SwiftUI

enum TimeOptions: String {
    case days = "Days"
    case hours = "Hours"
    case minutes = "Minutes"
    case seconds = "Seconds"
}

struct ContentView: View {
    @State private var input = ""
    @State private var inputSelection = 0
    @State private var outputSelection = 0
    private var conversionOptions: [TimeOptions] = [.days, .hours, .minutes, .seconds]

    var convertedValue: Double {
        let inputTime = Double(input) ?? 0

        var inputInSeconds = 0.0
        switch conversionOptions[inputSelection] {
        case .days:
            inputInSeconds = inputTime * 86400
        case .hours:
            inputInSeconds = inputTime * 3600
        case .minutes:
            inputInSeconds = inputTime * 60
        case .seconds:
            inputInSeconds = inputTime
        }

        switch conversionOptions[outputSelection] {
        case .days:
            return inputInSeconds / 86400
        case .hours:
            return inputInSeconds / 3600
        case .minutes:
            return inputInSeconds / 60
        case .seconds:
            return inputInSeconds
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter units to convert")) {
                    TextField("Time", text: $input).keyboardType(.decimalPad)
                    Picker("Tme", selection: $inputSelection) {
                        ForEach(0 ..< conversionOptions.count) {
                            Text("\(conversionOptions[$0].rawValue)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Output")) {
                    Picker("Tme", selection: $outputSelection) {
                        ForEach(0 ..< conversionOptions.count) {
                            Text("\(conversionOptions[$0].rawValue)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Text("\(convertedValue, specifier: "%.2f") \(conversionOptions[outputSelection].rawValue)")
                }
            }

            .navigationBarTitle("Converting Time")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
