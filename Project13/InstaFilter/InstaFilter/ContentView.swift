//
//  ContentView.swift
//  InstaFilter
//
//  Created by Zaheer Moola on 2021/07/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
        @State private var showingImagePicker = false

        var body: some View {
            VStack {
                image?
                    .resizable()
                    .scaledToFit()

                Button("Select Image") {
                   self.showingImagePicker = true
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker()
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
