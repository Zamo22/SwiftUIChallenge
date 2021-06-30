//
//  ContentView.swift
//  WhatsThatFlag
//
//  Created by Zaheer Moola on 2021/06/24.
//

import SwiftUI

//Challenge 3
struct FlagImage: View {
    var imageName: String

    var body: some View {
        Image(decorative: imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var currentScore = 0

    @State private var correctFlagRotationAnimationAmount = 0.0
    @State private var incorrectFlagOpacityAmount = 1.0

    @State private var actualCorrectFlagAnimationAmount: CGFloat = 0.0


    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }

                ForEach(0 ..< 3) { number in
                    Button(action: {
                        withAnimation() {
                            flagTapped(number)
                        }
                    }) {
                        FlagImage(imageName: countries[number])
                            // Challenge 6 to add animations
                            .rotation3DEffect(
                                .degrees(correctAnswer == number ? correctFlagRotationAnimationAmount : 0),
                                axis: (x: 0, y: 1.0, z: 0.0))
                            .opacity(correctAnswer != number ? incorrectFlagOpacityAmount : 1)
                            .overlay(
                                Capsule()
                                    .stroke(Color.green)
                                    .scaleEffect(correctAnswer == number ?
                                                    actualCorrectFlagAnimationAmount : 0)
                                    .opacity(Double(2 - actualCorrectFlagAnimationAmount))
                                    .animation(Animation.easeOut(duration: actualCorrectFlagAnimationAmount > 0 ? 2 : 0)
                                                .repeatCount(3, autoreverses: false))
                            )
                    }

                    .alert(isPresented: $showingScore) {
                        Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                            askQuestion()
                        })
                    }

                }

                Text("Your current score is \(currentScore)")
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            currentScore += 1
            scoreTitle = "Correct!"
            scoreMessage = "Your score is \(currentScore)"
            correctFlagRotationAnimationAmount += 360
            incorrectFlagOpacityAmount = 0.25
            actualCorrectFlagAnimationAmount = 0
        } else {
            scoreTitle = "Wrong!"
            scoreMessage = "You tapped the flag of \(countries[number])"
            correctFlagRotationAnimationAmount = 0
            incorrectFlagOpacityAmount = 1
            actualCorrectFlagAnimationAmount = 2
        }

        showingScore = true
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        correctFlagRotationAnimationAmount = 0
        incorrectFlagOpacityAmount = 1.0
        actualCorrectFlagAnimationAmount = 0
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
