//
//  Line.swift
//  Render
//
//  Created by Kristian Trenskow on 30/06/2019.
//  Copyright © 2019 Kristian Trenskow. All rights reserved.
//

import Foundation
import CoreText

public class Line {
    
    public enum TruncationType {
        case start
        case middle
        case end
    }
    
    let pointer: CTLine
    
    init(pointer: CTLine) {
        self.pointer = pointer
    }
    
    public init(attributedString string: NSAttributedString) {
        self.pointer = CTLineCreateWithAttributedString(string)
    }
    
}

extension Line {
    
    public func truncatedLine(width: CGFloat, truncationType: TruncationType = .end, token: Line? = nil) -> Line? {
        return CTLineCreateTruncatedLine(self.pointer, Double(width), truncationType.value, token?.pointer)
            .map(Line.init)
    }
    
    public func justifiedLine(factor: CGFloat, width: CGFloat) -> Line? {
        return CTLineCreateJustifiedLine(self.pointer, factor, Double(width))
            .map(Line.init)
    }
    
    public func draw(in context: CGContext) {
        CTLineDraw(self.pointer, context)
    }
    
    public var glyphCount: Int {
        return CTLineGetGlyphCount(self.pointer)
    }
    
    public var glyphRuns: [Run] {
        return (CTLineGetGlyphRuns(self.pointer) as? [CTRun])?.map(Run.init) ?? []
    }
    
    public var stringRange: Range {
        return Range(cfRange: CTLineGetStringRange(self.pointer))
    }
    
    public func penOffset(forFlushFactor factor: CGFloat, width: CGFloat) -> CGFloat {
        return CGFloat(CTLineGetPenOffsetForFlush(self.pointer, factor, Double(width)))
    }
    
    public func imageBounds(in context: CGContext?) -> CGRect {
        return CTLineGetImageBounds(self.pointer, context)
    }
    
    public var typographicBounds: TypographicBounds? {
        
        var ascent: CGFloat = 0.0
        var descent: CGFloat = 0.0
        var leading: CGFloat = 0.0
        
        let width = CTLineGetTypographicBounds(self.pointer, &ascent, &descent, &leading)
        
        guard width > 0 else { return nil }
        
        return TypographicBounds(
            acsent: ascent,
            descent: descent,
            leading: leading,
            width: CGFloat(width))
        
    }
    
    public var trailingWhitespaceWidth: CGFloat {
        return CGFloat(CTLineGetTrailingWhitespaceWidth(self.pointer))
    }
    
    public func stringIndex(forPosition position: CGPoint) -> Int? {
        
        let stringIndex = CTLineGetStringIndexForPosition(self.pointer, position)
        
        guard stringIndex != kCFNotFound else { return nil }
        
        return stringIndex
        
    }
    
    public func offsetForString(charIndex: Int) -> (primary: CGFloat, secondary: CGFloat) {
        
        var secondary: CGFloat = 0.0
        
        let primary = CTLineGetOffsetForStringIndex(self.pointer, charIndex, &secondary)
        
        return (primary, secondary)
        
    }
    
}

extension Line.TruncationType {
    var value: CTLineTruncationType {
        switch self {
        case .start:
            return .start
        case .middle:
            return .middle
        case .end:
            return .end
        }
    }
}

extension Line: Equatable {
    public static func ==(lhs: Line, rhs: Line) -> Bool {
        return lhs.pointer === rhs.pointer
    }
}
