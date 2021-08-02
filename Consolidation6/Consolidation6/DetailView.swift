//
//  DetailView.swift
//  Consolidation6
//
//  Created by Zaheer Moola on 2021/08/02.
//

import SwiftUI

struct DetailView: View {
    @State var image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .padding()
            .scaledToFit()
    }
}
