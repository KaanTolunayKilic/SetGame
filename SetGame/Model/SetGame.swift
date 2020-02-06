//
//  SetGame.swift
//  SetGame
//
//  Created by Kaan Tolunay Kilic on 01.02.20.
//  Copyright © 2020 Kaan Tolunay Kilic. All rights reserved.
//

import Foundation

class SetGame {
    private let IS_DEBUG = false
    
    private let NEEDS_MATCHABLE_CARDS = 3
    
    private var deck: [Card] = SetGame.createDeck()
    
    var isDeckEmpty: Bool { return deck.isEmpty }
    
    private(set) var playedCards = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var matchedCards = [Card]()
    
    private(set) var score: Int = 0
    
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
                _ = replaceMatchedCards()
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
        
        let firstCard = selectedCards[0]
        let secondCard = selectedCards[1]
        let thirdCard = selectedCards[2]
        
        let colors: Set<Card.Color> = [firstCard.color, secondCard.color, thirdCard.color]
        let shapes: Set<Card.Shape> = [firstCard.shape, secondCard.shape, thirdCard.shape]
        let fills: Set<Card.Fill> = [firstCard.fill, secondCard.fill, thirdCard.fill]
        let amounts: Set<Card.Amount> = [firstCard.amount, secondCard.amount, thirdCard.amount]
        
        return (
            colors.count != 2 &&
            shapes.count != 2 &&
            fills.count != 2 &&
            amounts.count != 2
        ) || IS_DEBUG
    }
    
    func restart() {
        deck = SetGame.createDeck()
        playedCards.removeAll()
        selectedCards.removeAll()
        matchedCards.removeAll()
        score = 0
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
