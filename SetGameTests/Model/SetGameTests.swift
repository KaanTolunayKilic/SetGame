//
//  SetGameTests.swift
//  SetGameTests
//
//  Created by Kaan Tolunay Kilic on 01.02.20.
//  Copyright © 2020 Kaan Tolunay Kilic. All rights reserved.
//

import XCTest
@testable import SetGame

class SetGameTests: XCTestCase {
    
    private var setGame: SetGame!

    override func setUp() {
        setGame = SetGame()
    }
    
    func testDeal3Cards() {
        let dealedCards = setGame.deal3Cards()
        XCTAssert(setGame.playedCards.count == 3, "There should be 3 cards to play with")
        
        for card in dealedCards {
            XCTAssert(setGame.playedCards.contains(card), "The Card [\(card)] should be played")
        }
    }

    func testChooseSingleCard() {
        _ = setGame.deal3Cards()
        setGame.chooseCard(atIndex: 0)
        XCTAssert(setGame.selectedCards.count == 1, "There should be 1 selected card")
    }
}
