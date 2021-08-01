//
//  ContentView.swift
//  WordScramble
//
//  Created by Zaheer Moola on 2021/06/29.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""

    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false

    // Challenge 5-> Calculate score
    var scoreMessage: String {
        var scoreCount = 0
        for word in usedWords {
            if word.count > 5 {
                scoreCount += 3
            } else if word.count > 4 {
                scoreCount += 2
            } else {
                scoreCount += 1
            }
        }
        return "Your current score is: \(scoreCount)"
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                List(usedWords, id: \.self) { word in
                    HStack {
                        Image(systemName: "\(word.count).circle")
                        Text(word)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text("\(word), \(word.count) letters"))

                }

                Text(scoreMessage)
                    .font(.headline)
            }
            .navigationBarTitle(rootWord)
            //Challenge 5 -> Restart game via bar button
            .navigationBarItems(leading:
                Button(action: startGame) {
                    Text("Restart game")
                }
            )
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle),
                      message: Text(errorMessage),
                      dismissButton: .default(Text("Ok")))
            }
        }
    }

    func startGame() {
        usedWords = []
        newWord = ""
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"),
           let startWords = try? String(contentsOf: startWordsURL) {
            let allWords = startWords.components(separatedBy: "\n")
            rootWord = allWords.randomElement() ?? "silkworm"
            return
        }
        fatalError("Could not load start.txt from bundle.")
    }

    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !answer.isEmpty else {
            wordError(title: "Word is empty",
                      message: "You need to actually supply a word")
            return
        }

        guard isOriginal(word: answer) else {
            wordError(title: "Word used already",
                      message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized",
                      message: "You can't just make them up, you know!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not possible",
                      message: "That isn't a real word.")
            return
        }

        usedWords.insert(answer, at: 0)
        newWord = ""
    }

    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }

    func isOriginal(word: String) -> Bool {
        // Challenge 5 -> Disable entering the word itself
        guard word != rootWord else { return false }
        return !usedWords.contains(word)
    }

    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }

    func isReal(word: String) -> Bool {
        //Challenge 4 -> Disallow words less than 3 chars
        guard word.count > 3 else { return false }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0,
                                                            wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
