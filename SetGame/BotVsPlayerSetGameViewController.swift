//
//  BotVsPlayerSetGameViewController.swift
//  SetGame
//
//  Created by Kaan Tolunay Kilic on 07.02.20.
//  Copyright © 2020 Kaan Tolunay Kilic. All rights reserved.
//

import UIKit

class BotVsPlayerSetGameViewController: SinglePlayerSetGameViewController {
    
    private var bot: SetGame.Bot!
    
    @IBOutlet weak var botReaktionLabel: UILabel!
    
    private var status: BotStatus? {
        didSet {
            switch status {
            case .searching: botReaktionLabel.text = "🧐"
            case .found: botReaktionLabel.text = "😃"
            case .succeeded: botReaktionLabel.text = "😂"
            case .failed: botReaktionLabel.text = "😢"
            case .none: break
            }
            updateViewFromModel()
        }
    }
    
    private enum BotStatus {
        case searching, found, succeeded, failed
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bot = setGame.createBot()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if self.bot.hasNoSet {
                if self.status == .succeeded || self.status == .failed || self.status == nil {
                    self.status = .searching
                } else if self.bot.findSets() {
                    self.status = .found
                }
            } else if self.bot.removeRandomSet() {
                self.status = .succeeded
                self.bot.clearSets()
            } else {
                self.status = .failed
            }
        }
    }
}
