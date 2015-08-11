//
//  StringUtility.swift
//  Blocs
//
//  Created by Leah Ferrell on 8/11/15.
//  Copyright (c) 2015 Leah Ferrell. All rights reserved.
//

import Foundation

public extension String
{
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
}