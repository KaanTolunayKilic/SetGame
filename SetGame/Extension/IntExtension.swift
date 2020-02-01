//
//  IntExtensions.swift
//  SetGame
//
//  Created by Kaan Tolunay Kilic on 01.02.20.
//  Copyright © 2020 Kaan Tolunay Kilic. All rights reserved.
//

import Foundation

extension Int {
    var arc4randomNumber: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else {
            return 0
        }
    }
}
