//
//  RatingView.swift
//  Bookworm
//
//  Created by Zaheer Moola on 2021/07/17.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int

    var maximumRating = 5
    var label = ""

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow

    var body: some View {
        HStack {
            if !label.isEmpty {
                Text(label)
            }

            ForEach(1..<maximumRating + 1) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
                    .accessibility(label: Text("\(number == 1 ? "1 star" : "\(number) stars")"))
                    .accessibility(removeTraits: .isImage)
                    .accessibility(addTraits: number > self.rating ? .isButton : [.isButton, .isSelected])
            }
        }
    }

    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
