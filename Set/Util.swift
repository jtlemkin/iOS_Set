//
//  Util.swift
//  Set
//
//  Created by James Lemkin on 12/27/19.
//  Copyright © 2019 James Lemkin. All rights reserved.
//

import Foundation

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
