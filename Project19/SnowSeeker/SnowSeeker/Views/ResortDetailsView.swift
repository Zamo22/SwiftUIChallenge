//
//  ResortDetailsView.swift
//  SnowSeeker
//
//  Created by Zaheer Moola on 2021/08/16.
//

import SwiftUI

struct ResortDetailsView: View {
    let resort : Resort
    
    var size: String {
        switch resort.size {
        case 1:
            return "Small"
        case 2:
            return "Medium"
        default:
            return "Large"
        }
    }
    
    var price: String {
        String(repeating: "$", count: resort.price)
    }
    
    var body: some View {
        Group {
            Text("Size: \(size)").layoutPriority(1)
            Spacer().frame(height: 0)
            Text("Price: \(price)").layoutPriority(1)
        }
    }
}

struct ResortDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ResortDetailsView(resort: Resort.example)
    }
}
