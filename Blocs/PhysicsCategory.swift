//
//  PhysicsCategory.swift
//  Blocs
//
//  Created by Leah Ferrell on 8/6/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None:  UInt32 = 0
    static let Ball:   UInt32 = 0b1   // 1
    static let Block: UInt32 = 0b10  // 2
    static let Paddle:   UInt32 = 0b100 // 4
}