//
//  ViewController.swift
//  Set
//
//  Created by James Lemkin on 1/1/18.
//  Copyright © 2018 James Lemkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game = Set()
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
        } else {
            print("chosen card was not in cardButtons")
        }
        updateViewFromModel()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Set()
        updateViewFromModel()
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var drawThreeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for card in cardButtons {
            card.layer.borderWidth = 3.0
            card.layer.cornerRadius = 8.0
        }
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        scoreLabel.text = "Sets Matched: \(game.setsMatched)"
        
        for index in 0..<game.activeCards.count {
            cardButtons[index].alpha = 1
            cardButtons[index].layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            //cardButtons[index].setTitle("\(game.activeCards[index].color.rawValue) \(game.activeCards[index].shape.rawValue) \(game.activeCards[index].shading.rawValue) \(game.activeCards[index].number.rawValue)", for: UIControlState.normal)
            cardButtons[index].setAttributedTitle(getButtonLabel(card: game.activeCards[index]), for: UIControlState.normal)
        }
        
        for index in 0..<game.selectedCards.count {
            let highlightedButton = cardButtons[game.activeCards.index(of: game.selectedCards[index])!]
            highlightedButton.layer.borderColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        }
        
        for card in cardButtons[game.activeCards.count...] {
            card.alpha = 0
        }
        
        if game.cardsInDeck.count == 0 {
            drawThreeButton.alpha = 0.25
        } else {
            drawThreeButton.alpha = 1
        }
    }
    
    @IBAction func dealThreeMoreCards(_ sender: UIButton) {
        game.dealThreeMoreCards()
        updateViewFromModel()
    }
    
    private func getButtonLabel(card: Card) -> NSAttributedString {
        var displayAlpha: CGFloat {
            switch card.shading {
            case.first:
                return 1.0
            case.second:
                return 0.3
            case.third:
                return 0.0
            default:
                return 1.0
            }
        }
        
        var displayColor: UIColor {
            switch card.color {
            case .first:
                return #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1).withAlphaComponent(displayAlpha)
            case .second:
                return #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1).withAlphaComponent(displayAlpha)
            case .third:
                return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).withAlphaComponent(displayAlpha)
            case .none:
                return .white
            }
        }
        
        var displayShape: String {
            switch card.shape {
            case .first:
                return "▲"
            case .second:
                return "●"
            case .third:
                return "■"
            case .none:
                return ""
            }
        }
        
        let attributes: [NSAttributedStringKey : Any] = [
            .foregroundColor : displayColor,
            .strokeColor : displayColor.withAlphaComponent(1.0),
            .strokeWidth : -8.0
            
        ]
        
        var text = ""
        
        for _ in 1...card.number.rawValue {
            text += displayShape
        }
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        return attributedText
    }
    
    @IBAction func cheat(_ sender: UIButton) {
        game.cheat()
        updateViewFromModel()
    }
    
}

extension Int {
    func arc4Random() -> Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
