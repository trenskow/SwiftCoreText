//
//  Typesetter.swift
//  Render
//
//  Created by Kristian Trenskow on 30/06/2019.
//  Copyright © 2019 Kristian Trenskow. All rights reserved.
//

import CoreText
import Foundation

public class Typesetter {
    
    public enum Error: Swift.Error {
        case unknownError
    }
    
    public enum Options {
        case forcedEmbedding(level: Int)
    }
    
    let pointer: CTTypesetter
    
    public init(attributedString string: NSAttributedString, options: [Options] = []) throws {
        
        guard let pointer = CTTypesetterCreateWithAttributedStringAndOptions(
            string,
            options.map({ $0.value }).reduce([:], +) as CFDictionary)
            else { throw Error.unknownError }
        
        self.pointer = pointer
        
    }
    
    init(pointer: CTTypesetter) {
        self.pointer = pointer
    }
    
}

extension Typesetter {
    
    public func line(fromRange range: Range, offset: CGFloat = 0.0) throws -> Line {
        return Line(pointer: CTTypesetterCreateLineWithOffset(self.pointer, range.cfRange, Double(offset)))
    }
    
    public func suggestLineBreak(startIndex: Int, width: CGFloat, offset: CGFloat = 0.0) -> Int {
        return CTTypesetterSuggestLineBreakWithOffset(self.pointer, startIndex, Double(width), Double(offset))
    }
    
    public func suggestClusterBreak(startIndex: Int, width: CGFloat, offset: CGFloat = 0.0) -> Int {
        return CTTypesetterSuggestClusterBreakWithOffset(self.pointer, startIndex, Double(width), Double(offset))
    }
    
}

extension Typesetter.Options {
    
    fileprivate var value: [CFString: Any] {
        switch self {
        case .forcedEmbedding(var level):
            return [kCTTypesetterOptionForcedEmbeddingLevel: CFNumberCreate(nil, .intType, &level)!]
        }
    }
    
}

extension Typesetter: Equatable {
    
    public static func ==(lhs: Typesetter, rhs: Typesetter) -> Bool {
        return lhs.pointer === rhs.pointer
    }
    
}
