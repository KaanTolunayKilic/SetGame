//
//  ViewController.swift
//  SetGame
//
//  Created by Kaan Tolunay Kilic on 01.02.20.
//  Copyright © 2020 Kaan Tolunay Kilic. All rights reserved.
//

import UIKit

class SinglePlayerSetGameViewController: UIViewController {
    
    let FONT_SIZE: CGFloat = 24
    let CARDS_AT_START: Int = 12
    
    private var setGame = SetGame(cardsAtStart: 12)
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardViews: [CardView]!
    
    @IBOutlet weak var deal3MoreCardsButton: UIButton! {
        didSet {
            let buttonAttributedString = NSMutableAttributedString(
                string: deal3MoreCardsButton.titleLabel?.text ?? "",
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.gray
                ]
            )
            deal3MoreCardsButton.setAttributedTitle(buttonAttributedString, for: .disabled)
        }

    }
    
    @IBAction func touchedCardView(_ sender: CardView) {
        assert(cardViews.contains(sender))
        setGame.chooseCard(atIndex: cardViews.firstIndex(of: sender)!)
        updateViewFromModel()
    }
    
    @IBAction func touchedRestart(_ sender: UIButton) {
        setGame = SetGame(cardsAtStart: CARDS_AT_START)
        updateViewFromModel()
    }
    
    @IBAction func touchDeal3MoreCards(_ sender: UIButton) {
        if setGame.playedCards.count < 24 && !setGame.isDeckEmpty {
            setGame.deal3Cards()
            updateViewFromModel()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardViews.indices {
            if index < setGame.playedCards.count {
                showCardAtIndex(index)
            } else {
                hideCardAtIndex(index)
            }
        }
        deal3MoreCardsButton.isEnabled = setGame.playedCards.count < cardViews.count && !setGame.isDeckEmpty
        scoreLabel.text = "Score: \(setGame.score)"
    }
    
    private func showCardAtIndex(_ index: Int) {
        assert(index >= 0 && index <= cardViews.count)
        assert(index >= 0 && index <= setGame.playedCards.count)
        
        let cardModel = setGame.playedCards[index]
        
        cardViews[index].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cardViews[index].layer.borderWidth = 5
        cardViews[index].layer.cornerRadius = 5
        
        if let isMatch = setGame.hasMatch(), setGame.selectedCards.contains(cardModel) {
            cardViews[index].layer.borderColor =  isMatch ? #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else if setGame.selectedCards.contains(cardModel) {
            cardViews[index].layer.borderColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        } else {
            cardViews[index].layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        var symbole: String
        switch cardModel.shape {
        case .first: symbole = "▲"
        case .second: symbole = "●"
        case .third: symbole = "■"
        }
        
        switch cardModel.amount {
        case .first: symbole = String(repeating: symbole, count: 1)
        case .second: symbole = String(repeating: symbole, count: 2)
        case .third: symbole = String(repeating: symbole, count: 3)
        }
        
        var attributes: Dictionary<NSAttributedString.Key, Any> = [:]
        
        switch cardModel.color {
        case .first: attributes[.foregroundColor] = UIColor.red
        case .second: attributes[.foregroundColor] = UIColor.green
        case .third: attributes[.foregroundColor] = UIColor.blue
        }
        
        switch cardModel.fill {
        case .first: break
        case .second: attributes[.strokeWidth] = 2
        case .third: attributes[.foregroundColor] = (attributes[.foregroundColor] as! UIColor).withAlphaComponent(0.2)
        }
        
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(FONT_SIZE)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        attributes[.font] = font
        
        let attributedString = NSMutableAttributedString(string: symbole, attributes: attributes)
        cardViews[index].setAttributedTitle(attributedString, for: .normal)
        cardViews[index].isEnabled = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateViewFromModel()
    }
    
    private func hideCardAtIndex(_ index: Int) {
        assert(index >= 0 && index <= cardViews.count)
        
        cardViews[index].backgroundColor = view.backgroundColor
        cardViews[index].setTitle("", for: .normal)
        cardViews[index].setAttributedTitle(NSAttributedString(), for: .normal)
        cardViews[index].isEnabled = false
        cardViews[index].layer.borderWidth = 0
        cardViews[index].layer.cornerRadius = 0
    }
}

