//
//  ImageNamer.swift
//  Consolidation6
//
//  Created by Zaheer Moola on 2021/08/02.
//

import SwiftUI

struct ImageNamer: View {
    @Binding var name: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField("What's this?", text: $name)
                .padding()

            Button("Save") {
                if !name.isEmpty {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Spacer()
        }
    }
}

struct ImageNamer_Previews: PreviewProvider {
    static var previews: some View {
        ImageNamer(name: .constant(""))
    }
}

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        let paths = self.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}
