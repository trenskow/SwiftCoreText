//
//  GlyphInfo.swift
//  TypeKit
//
//  Created by Kristian Trenskow on 06/07/2019.
//  Copyright © 2019 Kristian Trenskow. All rights reserved.
//

import CoreText

public class GlyphInfo {
    
    public enum CharacterCollection {
        case adobeCNS1
        case adobeGB1
        case adobeJapan1
        case adobeJapan2
        case adobeKorea1
        case identityMapping
    }
    
    let pointer: CTGlyphInfo
    
    public init?(glyphName: String, font: Font, baseString: String) {
        guard let pointer = CTGlyphInfoCreateWithGlyphName(
            glyphName as CFString,
            font.pointer,
            baseString as CFString)
            else { return nil }
        self.pointer = pointer
    }
    
    public init?(glyph: CGGlyph, font: Font, baseString: String) {
        guard let pointer = CTGlyphInfoCreateWithGlyph(
            glyph,
            font.pointer,
            baseString as CFString)
            else { return nil }
        self.pointer = pointer
    }
    
}

extension GlyphInfo {
    
    public var name: String? {
        return CTGlyphInfoGetGlyphName(self.pointer) as String?
    }
    
    public var characterIdentifier: CGFontIndex {
        return CTGlyphInfoGetCharacterIdentifier(self.pointer)
    }
    
    public var characterCollection: CharacterCollection {
        return CharacterCollection(from: CTGlyphInfoGetCharacterCollection(self.pointer))
    }
    
}

extension GlyphInfo.CharacterCollection {
    
    init(from characterCollection: CTCharacterCollection) {
        switch characterCollection {
        case .adobeCNS1:
            self = .adobeCNS1
        case .adobeGB1:
            self = .adobeGB1
        case .adobeJapan1:
            self = .adobeJapan1
        case .adobeJapan2:
            self = .adobeJapan2
        case .adobeKorea1:
            self = .adobeKorea1
        case .identityMapping:
            self = .identityMapping
        @unknown default:
            fatalError()
        }
    }
    
    var value: GlyphInfo.CharacterCollection {
        switch self {
        case .adobeCNS1:
            return .adobeCNS1
        case .adobeGB1:
            return .adobeGB1
        case .adobeJapan1:
            return .adobeJapan1
        case .adobeJapan2:
            return .adobeJapan2
        case .adobeKorea1:
            return .adobeKorea1
        case .identityMapping:
            return .identityMapping
        }
    }
    
}
