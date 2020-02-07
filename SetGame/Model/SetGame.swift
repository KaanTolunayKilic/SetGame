//
//  SetGame.swift
//  SetGame
//
//  Created by Kaan Tolunay Kilic on 01.02.20.
//  Copyright © 2020 Kaan Tolunay Kilic. All rights reserved.
//

import Foundation

class SetGame
{
    private let DEBUG_MODE = false
    private let NEEDS_MATCHABLE_CARDS = 3
    
    private var deck: [Card] = SetGame.createDeck()
    
    var isDeckEmpty: Bool { return deck.isEmpty }
    
    private(set) var playedCards = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var matchedCards = [Card]()
    
    private(set) var score: Int = 0
    
    private(set) var bot: Bot?
    
    init(cardsAtStart amount: Int) {
        for _ in 0..<amount {
            playedCards.append(removeRandomCardFromDeck())
        }
    }
    
    func chooseCard(atIndex index: Int) -> Void {
        assert(index >= 0 && index <= playedCards.count)
        
        let choosenCard = playedCards[index]
        
        if selectedCards.count < 3 {
            if let indexOfSelectedCard = selectedCards.firstIndex(of: choosenCard) {
                selectedCards.remove(at: indexOfSelectedCard)
                score -= 1
            } else {
                selectedCards.append(choosenCard)
            }
        } else {
            if let isMatch = hasMatch(), isMatch {
                matchedCards += selectedCards
                replaceMatchedCards()
                score += 5
            } else {
                score -= 3
            }
            
            selectedCards.removeAll()
            if !matchedCards.contains(choosenCard) {
                selectedCards.append(choosenCard)
            }
        }
    }
    
    func deal3Cards() {
        assert(deck.count >= NEEDS_MATCHABLE_CARDS)
        
        if let isMatch = hasMatch(), isMatch {
            replaceMatchedCards()
        }
        
        addRandomCards()
    }
    
    func hasMatch() -> Bool? {
        assert(selectedCards.count >= 0 && selectedCards.count <= NEEDS_MATCHABLE_CARDS)
        
        if selectedCards.count < NEEDS_MATCHABLE_CARDS {
            return nil
        }
        
        return SetGame.isMatch(
                    first: selectedCards[0],
                    second: selectedCards[1],
                    third: selectedCards[2]
                )
                ||
                DEBUG_MODE
    }
    
    private static func isMatch(first: Card, second: Card, third: Card) -> Bool {
        let colors: Set<Card.Color> = [first.color, second.color, third.color]
        let shapes: Set<Card.Shape> = [first.shape, second.shape, third.shape]
        let fills: Set<Card.Fill> = [first.fill, second.fill, third.fill]
        let amounts: Set<Card.Amount> = [first.amount, second.amount, third.amount]
        
        return (
            colors.count != 2 &&
            shapes.count != 2 &&
            fills.count != 2 &&
            amounts.count != 2
        )
    }
    
    func restart() {
        deck = SetGame.createDeck()
        playedCards.removeAll()
        selectedCards.removeAll()
        matchedCards.removeAll()
        score = 0
        bot = bot != nil ? Bot(game: self) : nil
    }
    
    func createBot() -> Bot {
        bot = Bot(game: self)
        return bot!
    }
    
    class Bot {
        private let game: SetGame
        private var sets = [[Card]]()
        private var score = 0
        
        var hasNoSet: Bool {
            return sets.isEmpty
        }
        
        init(game: SetGame) {
            self.game = game
        }
        
        func clearSets() {
            sets.removeAll()
        }
        
        func findSets() -> Bool {
            var found = false
            for first in game.playedCards.indices {
                for second in game.playedCards.indices[(first+1)...] {
                    for third in game.playedCards.indices[(second+1)...] {
                        if SetGame.isMatch(
                            first: game.playedCards[first],
                            second: game.playedCards[second],
                            third: game.playedCards[third]
                        ) {
                            let set = [game.playedCards[first], game.playedCards[second], game.playedCards[third]]
                            sets.append(set)
                            found = true
                        }
                    }
                }
            }
            return found
        }
        
        func removeRandomSet() -> Bool {
            while sets.count > 0 {
                let randomSet = sets.remove(at: sets.count.arc4randomNumber)
                let isAlreadyMatched = randomSet.reduce(false, {$0 || game.hasMatch() == true || game.selectedCards.contains($1)})
                if !isAlreadyMatched {
                    for card in randomSet {
                        if let indexOfSelectedCard = game.selectedCards.firstIndex(of: card) {
                            game.selectedCards.remove(at: indexOfSelectedCard)
                        }
                        
                        let removedCard = game.playedCards.remove(at: game.playedCards.firstIndex(of: card)!)
                        game.matchedCards.append(removedCard)
                    }
                    score += 5
                    return true
                }
            }
            score -= 3
            return false
        }
    }
    
    // MARK: private functions
    
    private func addRandomCards() {
        assert(hasMatch() == nil || hasMatch()! == false)
        
        for _ in 0..<NEEDS_MATCHABLE_CARDS {
            playedCards.append(removeRandomCardFromDeck())
        }
    }
    
    private func replaceMatchedCards() {
        assert(hasMatch()!)
        assert(selectedCards.count == 3)
        
        for selectedCard in selectedCards {
            let index = playedCards.firstIndex(of: selectedCard)!
            playedCards.remove(at: index)
            if !deck.isEmpty {
                let randomCard = removeRandomCardFromDeck()
                playedCards.insert(randomCard, at: index)
            }
        }
        selectedCards.removeAll()
    }
    
    private func removeRandomCardFromDeck() -> Card {
        assert(deck.count >= 0)
        return deck.remove(at: deck.count.arc4randomNumber)
    }
    
    // MARK: private static functions
    
    private static func createDeck() -> [Card] {
        var newDeck = [Card]()
        for color in Card.Color.all {
            for shape in Card.Shape.all {
                for fill in Card.Fill.all {
                    for amount in Card.Amount.all {
                        let card = Card(color: color, shape: shape, fill: fill, amount: amount)
                        newDeck.append(card)
                    }
                }
            }
        }
        return newDeck
    }
}
