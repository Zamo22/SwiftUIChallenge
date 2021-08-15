//
//  RollerView.swift
//  FinalChallenge
//
//  Created by Zaheer Moola on 2021/08/15.
//

import SwiftUI

enum DiceType: String, CaseIterable, Equatable {
    case d4 = "d4"
    case d6 = "d6"
    case d8 = "d8"
    case d10 = "d10"

    var maximumNumber: Int {
        switch self {
        case .d4: return 4
        case .d6: return 6
        case .d8: return 8
        case .d10: return 10
        }
    }
}

struct RollerView: View {
    @State private var selectedDice = DiceType.d6
    @State private var rolledNumber = 1

    @State private var feedback = UINotificationFeedbackGenerator()

    @Environment(\.managedObjectContext) var moc

    var imageName : String {
        if rolledNumber > selectedDice.maximumNumber {
            return "\(selectedDice.rawValue)_1"
        }
        return "\(selectedDice.rawValue)_\(rolledNumber)"
    }

    var body: some View {

        NavigationView {
            VStack(alignment: .center, spacing: 40) {
                Picker("Dice to Roll", selection: $selectedDice) {
                    ForEach(DiceType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.top], 40)

                Image(imageName)
                    .padding()

                Button(action: {
                    rollDice()
                }) {
                    Text("Roll !")
                        .font(.title)
                        .frame(width: 300, height: 44)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }

                Spacer()
            }
            .navigationBarTitle("Roll a dice")
        }

    }

    private func rollDice() {
        // could put this in a loop but I'm lazy
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
            getRandomDice()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            getRandomDice()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            getRandomDice()
            feedback.prepare()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(350)) {
            getRandomDice()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600)) {
            getRandomDice()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(950)) {
            getRandomDice()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1300)) {
            getRandomDice()
            saveDiceRoll()
            feedback.notificationOccurred(.success)
        }
    }

    private func getRandomDice() {
        rolledNumber = Int.random(in: 1...selectedDice.maximumNumber)
    }

    private func saveDiceRoll() {
        let diceRoll = DiceRoll(context: moc)
        diceRoll.dateRolled = Date()
        diceRoll.diceRoll = Int16(rolledNumber)
        diceRoll.diceType = selectedDice.rawValue

        do { try self.moc.save() }
        catch {
            print(error.localizedDescription)
        }
    }
}

struct RollerView_Previews: PreviewProvider {
    static var previews: some View {
        RollerView()
    }
}
