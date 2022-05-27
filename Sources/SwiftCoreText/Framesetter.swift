//
//  Framesetter.swift
//  Render
//
//  Created by Kristian Trenskow on 30/06/2019.
//  Copyright © 2019 Kristian Trenskow. All rights reserved.
//

import Foundation
import CoreText
import CoreGraphics

public class Framesetter {
    
    let pointer: CTFramesetter
    
    public init(attributedString string: NSAttributedString) {
        self.pointer = CTFramesetterCreateWithAttributedString(string)
    }
    
}

extension Framesetter {
    
    public var typesetter: Typesetter {
        return Typesetter(pointer: CTFramesetterGetTypesetter(self.pointer))
    }
    
    public func frame(for path: CGPath, range: Range? = nil) -> Frame {
        return Frame(pointer: CTFramesetterCreateFrame(self.pointer, range?.cfRange ?? .zero, path, nil))
    }
    
    public func suggestFrame(forConstraints constraints: CGSize = .max, fromRange range: Range? = nil) -> (size: CGSize, fittetRange: Range) {
        
        var fittedRange: CFRange = .zero
        
        let size = CTFramesetterSuggestFrameSizeWithConstraints(self.pointer, range?.cfRange ?? .zero, nil, constraints, &fittedRange)
        
        return (size, Range(cfRange: fittedRange))
        
    }
    
}

extension Framesetter: Equatable {
    public static func ==(lhs: Framesetter, rhs: Framesetter) -> Bool {
        return lhs.pointer === rhs.pointer
    }
}
