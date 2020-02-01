//
//  Card.swift
//  SetGame
//
//  Created by Kaan Tolunay Kilic on 01.02.20.
//  Copyright © 2020 Kaan Tolunay Kilic. All rights reserved.
//

import Foundation

struct Card: Equatable {
    let color: Color
    let shape: Shape
    let fill: Fill
    let amount: Amount
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return (
            lhs.color == rhs.color &&
            lhs.shape == rhs.shape &&
            lhs.fill == rhs.fill &&
            lhs.amount == rhs.amount
        )
    }
    
    // MARK: card attributes
    
    enum Color: CardAttribute {
        case first, second, third
        
        static var all: [Card.Color] {
            return [.first, .second, .third]
        }
    }
    
    enum Shape: CardAttribute {
        case first, second, third
        
        static var all: [Card.Shape] {
            return [.first, .second, .third]
        }
    }
    
    enum Fill: CardAttribute {
        case first, second, third
        
        static var all: [Card.Fill] {
            return [.first, .second, .third]
        }
    }
    
    enum Amount: CardAttribute {
        case first, second, third
        
        static var all: [Card.Amount] {
            return [.first, .second, .third]
        }
    }
}



