//
//  Frame.swift
//  TypeKit
//
//  Created by Kristian Trenskow on 30/06/2019.
//  Copyright © 2019 Kristian Trenskow. All rights reserved.
//

import CoreText
import Foundation

extension NSAttributedString.Key {
	
	public static let frameProgression =
		NSAttributedString.Key(rawValue: kCTFrameProgressionAttributeName as String)
	public static let framePathFillRule =
		NSAttributedString.Key(rawValue: kCTFramePathFillRuleAttributeName as String)
	public static let framePathWidth =
		NSAttributedString.Key(rawValue: kCTFramePathWidthAttributeName as String)
	public static let frameClippingPaths =
		NSAttributedString.Key(rawValue: kCTFrameClippingPathsAttributeName as String)
	public static let framePathClippingPath =
		NSAttributedString.Key(rawValue: kCTFramePathClippingPathAttributeName as String)
	
}

public class Frame {
	
	public enum PathFillRule: Int {
		case evenOdd = 0
		case windingNumber = 1
	}
	
	public enum Progression: Int {
		case topToBottom = 0
		case rightToLeft = 1
		case leftToRight = 2
	}
    
    let pointer: CTFrame
    
    init(pointer: CTFrame) {
        self.pointer = pointer
    }
	
	public lazy var lines: [FrameLine] = {
		
		let lines = (CTFrameGetLines(self.pointer) as? [CTLine])?.map(Line.init) ?? []
		
		let lineCount = lines.count
		var lineOrigins = [CGPoint](repeating: .zero, count: lineCount)
		
		CTFrameGetLineOrigins(self.pointer, .zero, &lineOrigins)
		
		return lines.enumerated().map { item in
			return FrameLine(
				line: item.element,
				origin: lineOrigins[item.offset])
		}
		
	}()
	
}

extension Frame {
	
	public struct FrameLine {
		public let line: Line
		public let origin: CGPoint
	}
    
    public var stringRange: Range {
        return Range(cfRange: CTFrameGetStringRange(self.pointer))
    }
    
    public var visibleStringRange: Range {
        return Range(cfRange: CTFrameGetVisibleStringRange(self.pointer))
    }
    
    public var path: CGPath {
        return CTFrameGetPath(self.pointer)
    }
	
    public func draw(in context: CGContext) {
        CTFrameDraw(self.pointer, context)
    }
	
	public var attributes: [NSAttributedString.Key: Any] {
		return (CTFrameGetFrameAttributes(self.pointer) as? [NSAttributedString.Key: Any]) ?? [:]
	}
    
}

extension Frame: Equatable {
    public static func ==(lhs: Frame, rhs: Frame) -> Bool {
        return lhs.pointer === rhs.pointer
    }
}
