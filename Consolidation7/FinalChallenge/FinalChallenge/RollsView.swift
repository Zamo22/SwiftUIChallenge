//
//  RollsView.swift
//  FinalChallenge
//
//  Created by Zaheer Moola on 2021/08/16.
//

import SwiftUI

struct RollsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: DiceRoll.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \DiceRoll.dateRolled, ascending: false)]) var diceRolls: FetchedResults<DiceRoll>

    var body: some View {
        NavigationView {
            List(diceRolls, id: \.self) { roll in
                HStack {
                    Text("Rolled on \(dateString(from: roll.dateRolled))")
                    Spacer()
                    Image(imageName(from: roll))
                        .resizable()
                        .frame(width: 125, height: 50)
                        .scaledToFill()
                }
            }
            .navigationBarTitle("Previous Rolls")
        }
    }

    func dateString(from date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: date)
    }

    func imageName(from roll: DiceRoll) -> String {
        "\(roll.diceType ?? "")_\(roll.diceRoll)"
    }
}

struct RollsView_Previews: PreviewProvider {
    static var previews: some View {
        RollsView()
    }
}
