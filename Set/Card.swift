//
//  Card.swift
//  Set
//
//  Created by James Lemkin on 1/2/18.
//  Copyright © 2018 James Lemkin. All rights reserved.
//

import Foundation

struct Card: Hashable
{
    
    enum Attribute: Int, CaseIterable
    {
        case first = 1, second, third
    }
    
    typealias Color = Attribute
    typealias Shape = Attribute
    typealias Shading = Attribute
    typealias Number = Attribute
    
    let color : Color
    let shape : Shape
    let shading : Shading
    let number : Number
    
    private let identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    init(color: Color, shape: Shape, shading: Shading, number: Number) {
        self.color = color
        self.shape = shape
        self.shading = shading
        self.number = number
        identifier = Card.getUniqueIdentifier()
    }
}
