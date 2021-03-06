//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by Zaheer Moola on 2021/07/17.
//

import SwiftUI

struct EmojiRatingView: View {
    let rating: Int16

    var body: some View {
        switch rating {
        case 1:
            return Text("đ¤Ž")
        case 2:
            return Text("âšī¸")
        case 3:
            return Text("đ")
        case 4:
            return Text("đ")
        default:
            return Text("đĨ°")
        }
    }
}

struct EmojiRatingView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRatingView(rating: 3)
    }
}
