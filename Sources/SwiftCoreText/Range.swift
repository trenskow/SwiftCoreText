//
//  Range.swift
//  TypeKit
//
//  Created by Kristian Trenskow on 30/06/2019.
//  Copyright © 2019 Kristian Trenskow. All rights reserved.
//

import Foundation

public struct Range {
    
    public let location: Int
    public let length: Int
    
    public init(location: Int, length: Int) {
        self.location = location
        self.length = length
    }
    
    init(cfRange: CFRange) {
        self.location = cfRange.location
        self.length = cfRange.length
    }
    
}

extension Range {
    
    public static var zero: Range {
        return Range(location: 0, length: 0)
    }
    
}

extension Range {
    
    var cfRange: CFRange {
        return CFRangeMake(self.location, self.length)
    }
    
}
