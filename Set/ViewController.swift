//
//  ViewController.swift
//  Set
//
//  Created by James Lemkin on 1/1/18.
//  Copyright © 2018 James Lemkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game = SetGame()
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    //Select a card
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
        } else {
            print("chosen card was not in cardButtons")
        }
        updateViewFromModel()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame()
        updateViewFromModel()
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var drawThreeButton: UIButton!
    
    //Make cards more presentable
    override func viewDidLoad() {
        super.viewDidLoad()
        for card in cardButtons {
            card.layer.borderWidth = 3.0
            card.layer.cornerRadius = 8.0
        }
        updateViewFromModel()
    }
    
    //Display active cards
    private func displayCards() {
        for index in game.activeCards.indices {
            cardButtons[index].alpha = 1
            cardButtons[index].layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cardButtons[index].setAttributedTitle(getButtonLabel(card: game.activeCards[index]), for: UIControl.State.normal)
        }
    }
    
    //Highlight cards selected by the player
    private func highlightSelectedCards() {
        for card in game.selectedCards {
            let index = game.activeCards.firstIndex(of: card)!
            let highlightedButton = cardButtons[index]
            
            highlightedButton.layer.borderColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        }
    }
    
    //Hides lingering cards that remain when the deck is empty
    private func hideInactiveCards() {
        for card in cardButtons[game.activeCards.count...] {
            card.alpha = 0
        }
    }
    
    //Update the label to show the current num sets matched
    private func updateLabelText() {
        scoreLabel.text = "Sets Matched: \(game.numSetsMatched)"
    }
    
    //Indicates to user that they are unable to draw any more cards
    private func setDrawCardButtonsAlpha() {
        drawThreeButton.alpha = game.cardsInDeck.isEmpty ? 0.25 : 1
    }
    
    private func updateViewFromModel() {
        updateLabelText()
        
        displayCards()
        
        highlightSelectedCards()
        
        hideInactiveCards()
        
        setDrawCardButtonsAlpha()
    }
    
    // Adds three additional cards to active cards
    @IBAction func drawThree(_ sender: UIButton) {
        game.dealMoreCards()
        updateViewFromModel()
    }
    
    private func getButtonLabel(card: Card) -> NSAttributedString {
        var displayAlpha: CGFloat {
            switch card.shading {
            case.first: return 1.0
            case.second: return 0.3
            case.third: return 0.0
            }
        }
        
        var displayColor: UIColor {
            switch card.color {
            case .first: return #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1).withAlphaComponent(displayAlpha)
            case .second: return #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1).withAlphaComponent(displayAlpha)
            case .third: return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).withAlphaComponent(displayAlpha)
            }
        }
        
        var displayShape: String {
            switch card.shape {
            case .first: return "▲"
            case .second: return "●"
            case .third: return "■"
            }
        }
        
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : displayColor,
            .strokeColor : displayColor.withAlphaComponent(1.0),
            .strokeWidth : -8.0
        ]
        
        let text = String(repeating: displayShape, count: card.number.rawValue)
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    //Find a set for the player
    @IBAction func cheat(_ sender: UIButton) {
        game.cheat()
        updateViewFromModel()
    }
    
}
