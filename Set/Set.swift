//
//  Set.swift
//  Set
//
//  Created by James Lemkin on 1/2/18.
//  Copyright © 2018 James Lemkin. All rights reserved.
//

import Foundation

class Set
{
    private(set) var setsMatched = 0
    
    private(set) var cardsInDeck = [Card]()
    private(set) var activeCards = [Card]()
    private(set) var selectedCards = [Card]()
    
    init() {
        cardsInDeck = allPossibleCards()
        dealCards(count: 12)
    }
    
    func chooseCard(at index: Int) {
        assert(activeCards.indices.contains(index), "Set.chooseCard(at: \(index)): chosen index not in the cards")
        
        if selectedCards.index(of: activeCards[index]) == nil {
            selectedCards.append(activeCards[index])
        } else {
            selectedCards.remove(at: selectedCards.index(of: activeCards[index])!)
            return
        }
        
        if selectedCards.count > 3 {
            selectedCards.removeAll()
            selectedCards.append(activeCards[index])
        }
        
        replaceSelectedCardsIfMatch()
    }
    
    private func replaceSelectedCardsIfMatch() {
        if selectedCards.count == 3 {
            if isSet(selectedCards) {
                setsMatched += 1
                
                for card in selectedCards {
                    if cardsInDeck.count > 0 {
                        activeCards[activeCards.index(of: card)!] = cardsInDeck.remove(at: cardsInDeck.count.arc4Random())
                    } else {
                        activeCards.remove(at: activeCards.index(of: card)!)
                    }
                }
            } else {
                print("Not a fucking match")
            }
            
            selectedCards.removeAll()
        }
    }
    
    private func isSet(_ cardsToCheck: [Card]) -> Bool {
        var colors = [Color]()
        var shapes = [Shape]()
        var shadings = [Shading]()
        var numbers = [Number]()
        
        for card in cardsToCheck {
            if colors.index(of: card.color) == nil {
                colors.append(card.color)
            }
            
            if shapes.index(of: card.shape) == nil {
                shapes.append(card.shape)
            }
            
            if shadings.index(of: card.shading) == nil {
                shadings.append(card.shading)
            }
            
            if numbers.index(of: card.number) == nil {
                numbers.append(card.number)
            }
        }

        //follows rule "If you can sort a group of three cards into "two of ____ and one of ____", then it is not a set."
        return colors.count != 2 && shapes.count != 2 && shadings.count != 2 && numbers.count != 2
    }
    
    private func dealCards(count: Int) {
        assert(count >= 0, "Set.dealCards(\(count)): chosen count less than 0")
        
        if cardsInDeck.count < 0 {
            return
        }
        
        if cardsInDeck.count >= count {
            for _ in 1...count {
                activeCards.append(cardsInDeck.remove(at: cardsInDeck.count.arc4Random()))
            }
        } else {
            if cardsInDeck.count > 0 {
                for _ in 1...cardsInDeck.count {
                    activeCards.append(cardsInDeck.remove(at: cardsInDeck.count.arc4Random()))
                }
            }
        }
    }
    
    func dealThreeMoreCards() {
        replaceSelectedCardsIfMatch()
    
        if (activeCards.count <= 21) {
            dealCards(count: 3)
        } else {
            print("cards full")
            if (24 - activeCards.count > 0) {
                dealCards(count: 24 - activeCards.count)
            }
        }
    }
    
    private func allPossibleCards() -> [Card] {
        var possibleCards = [Card]()
        let defaultCard = Card(color: .none, shape: .none, shading: .none, number: .none)
        
        //creates 27 cards using all possible combinations of attributes
        for color in defaultCard.color {
            for shape in defaultCard.shape {
                for shading in defaultCard.shading {
                    for number in defaultCard.number {
                        possibleCards.append(Card(color: color, shape: shape, shading: shading, number: number))
                    }
                }
            }
        }
        
        return possibleCards
    }
    
    private func findSet() -> [Card]? {
        var potentialSet = [Card]()
        
        for indexOfFirst in 0..<activeCards.count {
            for indexOfSecond in (indexOfFirst + 1)..<activeCards.count {
                for indexOfThird in (indexOfSecond + 1)..<activeCards.count {
                    potentialSet = [activeCards[indexOfFirst], activeCards[indexOfSecond], activeCards[indexOfThird]]
                    if isSet(potentialSet) {
                        return potentialSet
                    }
                }
            }
        }
        
        return nil
    }
    
    func cheat() {
        let set = findSet()
        
        if set != nil {
            selectedCards = set!
            replaceSelectedCardsIfMatch()
        } else {
            print("there are no sets")
        }
    }
}
