//
//  DetailView.swift
//  Consolidation6
//
//  Created by Zaheer Moola on 2021/08/02.
//

import SwiftUI

struct DetailView: View {
    @State var image: UIImage
    @State var annotation: CodableMKPointAnnotation

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .padding()
                .scaledToFit()
            
            MapView(annotation: annotation)
                .padding()
        }
    }
}
