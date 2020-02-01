//
//  SetGame.swift
//  SetGame
//
//  Created by Kaan Tolunay Kilic on 01.02.20.
//  Copyright © 2020 Kaan Tolunay Kilic. All rights reserved.
//

import Foundation

class SetGame {
    private let NEEDS_MATCHABLE_CARDS = 3
    
    private var deck: [Card] = SetGame.createDeck()
    
    private(set) var playedCards = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var matchedCards = [Card]()
    
    func chooseCard(atIndex index: Int) -> Void {
        assert(index >= 0 && index <= playedCards.count)
        
        let choosenCard = playedCards[index]
        
        if selectedCards.count < 3 {
            if let indexOfSelectedCard = selectedCards.firstIndex(of: choosenCard) {
                selectedCards.remove(at: indexOfSelectedCard)
            } else {
                selectedCards.append(choosenCard)
            }
        } else {
            if let isMatch = hasMatch(), isMatch {
                matchedCards += selectedCards
                _ = deal3Cards()
            }
            
            selectedCards.removeAll()
            if !matchedCards.contains(choosenCard) {
                selectedCards.append(choosenCard)
            }
        }
    }
    
    func deal3Cards() -> [Card] {
        assert(deck.count >= NEEDS_MATCHABLE_CARDS)
        
        if let isMatch = hasMatch(), isMatch {
            return replaceMatchedCards()
        }
        
        return addRandomCards()
    }
    
    func hasMatch() -> Bool? {
        assert(selectedCards.count >= 0 && selectedCards.count <= NEEDS_MATCHABLE_CARDS)
        
        if selectedCards.count < NEEDS_MATCHABLE_CARDS {
            return nil
        }
        
        let firstCard = selectedCards[0]
        let secondCard = selectedCards[1]
        let thirdCard = selectedCards[2]
        
        let colors = [firstCard.color, secondCard.color, thirdCard.color]
        let shapes = [firstCard.shape, secondCard.shape, thirdCard.shape]
        let fills = [firstCard.fill, secondCard.fill, thirdCard.fill]
        let amounts = [firstCard.amount, secondCard.amount, thirdCard.amount]
        
        return (
            colors.count != 2 &&
            shapes.count != 2 &&
            fills.count != 2 &&
            amounts.count != 2
        )
    }
    
    // MARK: private functions
    
    private func addRandomCards() -> [Card] {
        assert(hasMatch() == nil || hasMatch()! == false)
        
        var addedCards = [Card]()
        for _ in 0..<NEEDS_MATCHABLE_CARDS {
            addedCards.append(removeRandomCardFromDeck())
        }
        return addedCards
    }
    
    private func replaceMatchedCards() -> [Card] {
        assert(hasMatch()!)
        
        var replacedCards = [Card]()
        for selectedCard in selectedCards {
            let index = playedCards.firstIndex(of: selectedCard)!
            let randomCard = removeRandomCardFromDeck()
            playedCards.remove(at: index)
            playedCards.insert(randomCard, at: index)
            replacedCards.append(randomCard)
        }
        return replacedCards
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
