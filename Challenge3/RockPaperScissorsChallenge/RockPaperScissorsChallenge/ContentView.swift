//
//  ContentView.swift
//  RockPaperScissorsChallenge
//
//  Created by Zaheer Moola on 2021/06/26.
//

import SwiftUI

enum GameOption: String {
    case rock = "Rock"
    case paper = "Paper"
    case scissors = "Scissors"
}

struct GameButton: View {
    var text: String

    var body: some View {
        ZStack() {
            LinearGradient(gradient: Gradient(colors: [.red, .gray]),
                           startPoint: .top, endPoint: .bottomLeading)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipShape(Capsule())
            Text(text)
                .foregroundColor(.white)
                .font(.title2)
        }
    }
}

struct ContentView: View {
    let gameItems = ["Rock", "Paper", "Scissors"]
    @State private var gameChoice = Int.random(in: 0..<3)
    @State private var shouldWin = Bool.random()

    @State private var score = 0
    @State private var questionsAsked = 0
    @State private var gameOver = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.green, .white]),
                           startPoint: .top, endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("Your score is: \(score)")
                    .font(.title2)
                    .foregroundColor(.blue)
                Text("We play: \(gameItems[gameChoice])")
                    .font(.title)
                    .bold()
                Text("You need to \(shouldWin ? "Win" : "Lose")")
                    .font(.title3)
                HStack(spacing: 20) {
                    ForEach(gameItems, id: \.self) { option in
                        Button(action: {
                            optionTapped(option)
                        }) {
                            GameButton(text: option)
                        }
                    }
                }

                .alert(isPresented: $gameOver, content: {
                    Alert(title: Text("That's all folks"),
                          message: Text("Your score is \(score) points"),
                          dismissButton: .default(Text("Reset")) {
                            resetGame()
                          })
                })
            }
        }
    }

    func optionTapped(_ option: String) {
        guard let yourChoice = GameOption(rawValue: option),
              let gamesChoice = GameOption(rawValue: gameItems[gameChoice]) else {
            return
        }

        var beatTheGame = false
        switch gamesChoice {
        case .rock:
            beatTheGame = (yourChoice == .paper && shouldWin) ||
                (yourChoice == .scissors && !shouldWin)
        case .paper:
            beatTheGame = (yourChoice == .scissors && shouldWin) ||
                (yourChoice == .rock && !shouldWin)
        case .scissors:
            beatTheGame = (yourChoice == .rock && shouldWin) ||
                (yourChoice == .paper && !shouldWin)
        }

        gameChoice = Int.random(in: 0..<3)
        shouldWin = Bool.random()
        score = beatTheGame ? score + 1 : score - 1
        questionsAsked += 1
        gameOver = questionsAsked == 10
    }

    func resetGame() {
        score = 0
        questionsAsked = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
