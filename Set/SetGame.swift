//
//  Set.swift
//  Set
//
//  Created by James Lemkin on 1/2/18.
//  Copyright © 2018 James Lemkin. All rights reserved.
//

import Foundation

class SetGame
{
    private(set) var numSetsMatched = 0
    
    private(set) var cardsInDeck = [Card]()
    private(set) var activeCards = [Card]()
    
    //O(1)
    private(set) var selectedCards = [Card]() {
        didSet {
            if selectedCards.count == 3 {
                if isSet(selectedCards) {
                    numSetsMatched += 1
                    
                    replaceCards()
                }
                
                selectedCards.removeAll()
            }
        }
    }
    
    //O(1)
    private static var allPossibleCards : [Card] {
        var possibleCards = [Card]()
        
        //creates 81 cards using all possible combinations of attributes
        for color in Card.Color.allCases {
            for shape in Card.Shape.allCases {
                for shading in Card.Shading.allCases {
                    for number in Card.Number.allCases {
                        possibleCards.append(Card(color: color, shape: shape, shading: shading, number: number))
                    }
                }
            }
        }
        
        return possibleCards
    }
    
    init() {
        cardsInDeck = SetGame.allPossibleCards
        dealCards(count: 12)
    }
    
    //Select a card if it's not selected and unselect it if it is
    func chooseCard(at index: Int) {
        assert(activeCards.indices.contains(index), "Set.chooseCard(at: \(index)): chosen index not in the cards")
        
        let chosenCard = activeCards[index]
        
        if let cardIndex = selectedCards.firstIndex(of: chosenCard) {
            selectedCards.remove(at: cardIndex)
        } else {
            selectedCards += [chosenCard]
        }
    }
    
    //Deal 3 cards
    func dealMoreCards() {
        dealCards(count: 3)
    }
    
    //Select every triplet of cards until the first set is found
    func cheat() {
        let oldNumSetsMatched = numSetsMatched
        
        for indexOfFirst in 0..<activeCards.count {
            for indexOfSecond in (indexOfFirst + 1)..<activeCards.count {
                for indexOfThird in (indexOfSecond + 1)..<activeCards.count {
                    selectedCards = [activeCards[indexOfFirst], activeCards[indexOfSecond], activeCards[indexOfThird]]
                    
                    //Stop looking at triplets after the first set is found
                    if oldNumSetsMatched != numSetsMatched {
                        return
                    }
                }
            }
        }
    }
    
    //Moves cards from deck to the table
    private func replaceCards() {
        for card in selectedCards {
            let index = activeCards.firstIndex(of: card)!
            
            if cardsInDeck.count > 0 {
                activeCards[index] = cardsInDeck.remove(at: cardsInDeck.count.arc4Random())
            } else {
                activeCards.remove(at: index)
            }
        }
    }
    
    //Checks to see if 3 cards make a valid set
    private func isSet(_ cardsToCheck: [Card]) -> Bool {
        let colors = Set(cardsToCheck.map { $0.color })
        let shapes = Set(cardsToCheck.map { $0.shape })
        let shadings = Set(cardsToCheck.map { $0.shading })
        let numbers = Set(cardsToCheck.map { $0.number })
        
        //follows rule "If you can sort a group of three cards into "two of ____ and one of ____", then it is not a set."
        return colors.count != 2 && shapes.count != 2 && shadings.count != 2 && numbers.count != 2
    }
    
    private func dealCards(count: Int) {
        assert(count >= 0, "Set.dealCards(\(count)): chosen count less than 0")
        
        //Don't deal more cards than there are in the deck or than you have room for
        let numCardsToDeal = min(count, cardsInDeck.count, 24 - activeCards.count)
            
        //Add the cards to the active cards that you remove from deck
        activeCards += (0..<numCardsToDeal).map { _ in cardsInDeck.remove(at: cardsInDeck.count.arc4Random()) }
    }
}
