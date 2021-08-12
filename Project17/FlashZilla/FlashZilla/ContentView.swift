//
//  ContentView.swift
//  Project17
//
//  Created by Paul Hudson on 17/02/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled

    @State private var cards = [Card]()
    @State private var showingEditScreen = false
    @State private var showingSettingsScreen = false

    @State private var requeueCards = false

    @State private var timeRemaining = 100
    @State private var isActive = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {

                    Button(action: {
                        showingSettingsScreen = true
                    }) {
                        Image(systemName: "gear")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()

                    if timeRemaining > 0 {
                        Text("Time: \(timeRemaining)")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(Color.black)
                                    .opacity(0.75)
                            )
                    } else {
                        Text("Times up!")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(Color.black)
                                    .opacity(0.75)
                            )
                    }


                    Button(action: {
                        self.showingEditScreen = true
                    }) {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }


                ZStack {
                    ForEach(cards) { card in
                        CardView(card: card) { isIncorrect in
                            withAnimation {
                                self.removeCard(at: self.index(for: card), isIncorrect: isIncorrect)
                            }
                        }
                        .stacked(at: self.index(for: card), in: self.cards.count)
                        .allowsHitTesting(self.index(for: card) == self.cards.count - 1)
                        .accessibility(hidden: self.index(for: card) < self.cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)

                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }

            if differentiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()

                    HStack {
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1, isIncorrect: true)
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        Spacer()

                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.isActive = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if self.cards.isEmpty == false {
                self.isActive = true
            }
        }
        .onReceive(timer) { time in
            guard self.isActive else { return }
            if self.timeRemaining > 0 {
//                self.timeRemaining -= 1
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
            EditCards()
        }
        .sheet(isPresented: $showingSettingsScreen, onDismiss: resetCards) {
            SettingsView()
        }
        .onAppear(perform: resetCards)
    }

    func allows(index: Int) -> Bool {
        print(cards)
        return index == self.cards.count - 1
    }

    func removeCard(at index: Int, isIncorrect: Bool = false) {
        guard index >= 0 else { return }
        let card = cards[index]
        let newCard = Card(prompt: card.prompt, answer: card.answer)
        cards.remove(at: index)

        if requeueCards && isIncorrect {
            cards.insert(newCard, at: 0)
        }

        if cards.isEmpty {
            isActive = false
        }

        print(cards)
    }

    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }

    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }

        if let data = UserDefaults.standard.data(forKey: "Settings") {
            if let decoded = try? JSONDecoder().decode(Bool.self, from: data) {
                self.requeueCards = decoded
            }
        }
    }

    func index(for card: Card) -> Int {
            return cards.firstIndex(where: { $0.id == card.id }) ?? 0
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
