//
//  EmojiMemoryGame.swift
//  Concentration
//
//  Created by Rhea Malik on 6/19/21.
//  Copyright © 2021 Rhea Malik. All rights reserved.
//

import SwiftUI

// ViewModel
class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    private let travels = ["🚗", "🏎", "🚑", "🚜", "🛴", "🚀", "🛩", "🚁", "🛺", "🛵", "🚂", "🛸"]
    private let sports = ["⚽️", "🏀", "🏈", "🎾", "🥏", "🥍", "⚾️", "🏹", "⛳️"]
    private let animals = ["🐶", "🐷", "🐵", "🐥", "🦄", "🦋", "🐬", "🦒"]
    private let fruits = ["🍎", "🍐", "🍊", "🍌", "🫐", "🍍", "🍒", "🥭"]
    private let veggies = ["🌽", "🥦", "🥑", "🥒", "🫑", "🥬"]
    private let snacks = ["🥐", "🥨", "🍟", "🍦", "🍫", "🍪", "🧁", "🧇"]
    
    private var themes: [Theme<String>]
    private(set) var theme: Theme<String>
    
    init() {
        themes =
            [Theme(name: "Travel", emojis: travels.shuffled(), numPairs: 12, color: Color.red),
             Theme(name: "Sports", emojis: sports.shuffled(), numPairs: 8, color: Color.blue),
             Theme(name: "Animals", emojis: animals.shuffled(), numPairs: 6, color: Color.yellow),
             Theme(name: "Fruits", emojis: fruits.shuffled(), numPairs: 7, color: Color.purple),
             Theme(name: "Vegetables", emojis: veggies.shuffled(), numPairs: 5, color: Color.orange),
             Theme(name: "Snacks", emojis: snacks.shuffled(), numPairs: 8, color: Color.pink)]
        theme = themes[Int.random(in: 0..<themes.count)]
        model = createMemoryGame()
    }
    
    private func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairsOfCards: theme.numPairs) { pairIndex in
            return theme.emojis[pairIndex]
        }
    }
    
    //anytime this var changes, it will call objectWillChange.send() that comes with ObservableObject protocol
    @Published private var model: MemoryGame<String>!
    
    var cards: [Card] {
        return model.cards
    }
    
    //MARK: - Intent(s) (typically use animation)
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func refresh() {
        theme = themes[Int.random(in: 0..<themes.count)]
        model = createMemoryGame()
    }
    
    func getScore() -> Int {
        return model.score
    }
    
    func shuffle() {
        model.shuffle()
    }
}
