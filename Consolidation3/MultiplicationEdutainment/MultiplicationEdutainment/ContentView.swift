//
//  ContentView.swift
//  MultiplicationEdutainment
//
//  Created by Zaheer Moola on 2021/07/02.
//

import SwiftUI

enum Questions: String, CaseIterable, Identifiable {
    case five = "5"
    case ten = "10"
    case twenty = "20"
    case all = "ALL"

    var id: String { self.rawValue }
}

struct MultiplicationQuestion {
    let question: String
    let answer: Int
}

struct ContentView: View {
    @State private var hasSettings = false
    @State private var multiplicationTable = 2
    @State private var numberOfQuestions = Questions.five

    @State private var questions: [MultiplicationQuestion] = []
    @State private var currentQuestion = 0
    @State private var currentAnswer = ""
    @State private var score = 0

    @State private var alertMessage = ""
    @State private var showingGameEndedAlert = false

    @State private var settingsRotation = 0.0

    var body: some View {
        Group {
            if !hasSettings {
                VStack(spacing: 5) {
                    Image("parrot")
                        .rotation3DEffect(
                            .degrees(settingsRotation),
                            axis: (x: 1.0, y: 0.0, z: 0.0)
                        )
                        .onAppear() {
                            withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                                self.settingsRotation += 360
                            }
                        }

                    Form {
                        Section {
                            Text("What tables do you want to learn today?")
                                .font(.body)
                                .foregroundColor(.blue)
                            Stepper(value: $multiplicationTable, in: 1...12) {
                                Text("Up to \(multiplicationTable) times table")
                                    .foregroundColor(.orange)
                            }
                        }

                        Section {
                            Text("How many questions would you like to try?")
                                .font(.body)
                                .foregroundColor(.blue)
                            Picker("Number of Questions", selection: $numberOfQuestions) {
                                ForEach(Questions.allCases, id: \.self) {
                                    Text("\($0.rawValue)")
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                        }


                        Button(action: proceedToGame) {
                            Text("Let's go!")
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .animation(.easeInOut(duration: 4).repeatForever())
                                .font(.title)
                                .foregroundColor(.red)
                        }


                    }
                }
            } else {
                Form {
                    Text("What is \(questions[currentQuestion].question)?")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .transition(.slide)

                    TextField("Answer", text: $currentAnswer)
                        .font(.title)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Submit") {
                        submitAnswer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .font(.title)
                    .foregroundColor(.pink)

                }
                .alert(isPresented: $showingGameEndedAlert) {
                    Alert(title: Text("Well done!"), message: Text(alertMessage), dismissButton: .default(Text("Continue")) {
                        restartGame()
                    })
                }
            }
        }
    }

    func proceedToGame() {
        withAnimation {
            settingsRotation += 360
            generateQuestions()
            hasSettings = true
        }
    }

    func generateQuestions() {
        var potentialQuestions = [MultiplicationQuestion]()
        for number in 0...multiplicationTable {
            for newNum in number...multiplicationTable {
                let newQuestion = MultiplicationQuestion(question: "\(number) X \(newNum)",
                                                         answer: number * newNum)
                potentialQuestions.append(newQuestion)
            }
        }

        switch numberOfQuestions {
        case .five:
            questions = pickRandomQuestions(from: potentialQuestions, amount: 5)
        case .ten:
            questions = pickRandomQuestions(from: potentialQuestions, amount: 10)
        case .twenty:
            questions = pickRandomQuestions(from: potentialQuestions, amount: 20)
        case .all:
            questions = potentialQuestions
        }
    }

    func pickRandomQuestions(from questions: [MultiplicationQuestion],
                             amount: Int) -> [MultiplicationQuestion] {
        var randomQuestions = [MultiplicationQuestion]()
        for _ in 1...amount {
            let randomQuestion = questions.randomElement() ?? MultiplicationQuestion(question: "1 X 1", answer: 1)
            randomQuestions.append(randomQuestion)
        }
        return randomQuestions
    }

    func submitAnswer() {
        let expectedAnswer = questions[currentQuestion].answer
        guard let givenAnswer = Int(currentAnswer) else {
            return
        }

        if givenAnswer == expectedAnswer {
            score += 1
        } else {
            //I guess some animation
        }

        if currentQuestion < questions.count - 1 {
            currentQuestion += 1
        } else {
            endGame()
        }
        currentAnswer = ""
    }

    func endGame() {
        alertMessage = "You scored \(score) out of \(questions.count) questions"
        showingGameEndedAlert = true
    }

    func restartGame() {
        score = 0
        currentQuestion = 0
        questions = []
        hasSettings = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
