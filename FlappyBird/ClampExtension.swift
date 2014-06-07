//
//  ClampExtension.swift
//  FlappyBird
//
//  Created by :kelko: on 07.06.14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import Foundation

extension Float {
    func clampToValue(between min: Float, and max: Float) -> Float{
        if( self > max ) {
            return max
        } else if( self < min ) {
            return min
        } else {
            return self
        }
    }
}
