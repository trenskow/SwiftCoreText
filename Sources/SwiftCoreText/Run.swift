//
//  Run.swift
//  TypeKit
//
//  Created by Kristian Trenskow on 30/06/2019.
//  Copyright © 2019 Kristian Trenskow. All rights reserved.
//

import CoreText
import Foundation

public class Run {
    
    public struct Status: OptionSet {
        
        public typealias RawValue = UInt32
        
        public var rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
        public static var rightToLeft = CTRunStatus.rightToLeft
        public static var nonMonotonic = CTRunStatus.nonMonotonic
        public static var hasNonIdentityMatrix = CTRunStatus.hasNonIdentityMatrix
        
    }
    
    let pointer: CTRun
    
    init(pointer: CTRun) {
        self.pointer = pointer
    }
    
}

extension Run {
    
    public var glyphCount: Int {
        return CTRunGetGlyphCount(self.pointer)
    }
    
    public var status: Status {
        return Status(rawValue: CTRunGetStatus(self.pointer).rawValue)
    }
    
    private func get<T>(initialValue: T, fnc: (CTRun, CFRange, UnsafeMutablePointer<T>) -> Void) -> [T] {
        var result = [T](repeating: initialValue, count: self.glyphCount)
        fnc(self.pointer, .zero, &result)
        return result
    }
    
    public var glyphs: [CGGlyph] {
        return get(initialValue: 0, fnc: CTRunGetGlyphs)
    }
    
    public var positions: [CGPoint] {
        return get(initialValue: .zero, fnc: CTRunGetPositions)
    }
    
    public var advances: [CGSize] {
        return get(initialValue: .zero, fnc: CTRunGetAdvances)
    }
    
    public var stringIndices: [Int] {
        return get(initialValue: 0, fnc: CTRunGetStringIndices)
    }
    
    public var stringRange: Range {
        return Range(cfRange: CTRunGetStringRange(self.pointer))
    }
    
    public var typographicBounds: TypographicBounds? {
        
        var ascent: CGFloat = 0.0
        var descent: CGFloat = 0.0
        var leading: CGFloat = 0.0
        
        let width = CTRunGetTypographicBounds(self.pointer, .zero, &ascent, &descent, &leading)
        
        guard width > 0 else { return nil }
        
        return TypographicBounds(
            ascent: ascent,
            descent: descent,
            leading: leading,
            width: CGFloat(width))
        
    }
    
    public func imageBounds(in context: CGContext?) -> CGRect {
        return CTRunGetImageBounds(self.pointer, context, .zero)
    }
    
    public func draw(in context: CGContext) {
        CTRunDraw(self.pointer, context, .zero)
    }
    
    public var textMatrix: CGAffineTransform {
        return CTRunGetTextMatrix(self.pointer)
    }
    
    public var attributes: [NSAttributedString.Key: Any]? {
        return CTRunGetAttributes(self.pointer) as? [NSAttributedString.Key: Any]
    }
    
}

extension Run: Equatable {
    public static func ==(lhs: Run, rhs: Run) -> Bool {
        return lhs.pointer == rhs.pointer
    }
}
