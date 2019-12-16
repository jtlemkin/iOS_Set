//
//  Card.swift
//  Set
//
//  Created by James Lemkin on 1/2/18.
//  Copyright © 2018 James Lemkin. All rights reserved.
//

import Foundation

struct Card: Equatable
{
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var color : Color
    var shape : Shape
    var shading : Shading
    var number : Number
    var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init(color: Color, shape: Shape, shading: Shading, number: Number) {
        self.color = color
        self.shape = shape
        self.shading = shading
        self.number = number
        identifier = Card.getUniqueIdentifier()
    }
}

enum Attribute: Int, Sequence, IteratorProtocol
{
    case none = 0
    case first = 1
    case second = 2
    case third = 3
    
    mutating func next() -> Attribute? {
        switch self {
        case .none:
            self = .first
            return self
        case .first:
            self = .second
            return self
        case .second:
            self = .third
            return self
        case .third:
            self = .none
            return nil
        }
    }
}

typealias Color = Attribute
typealias Shape = Attribute
typealias Shading = Attribute
typealias Number = Attribute
