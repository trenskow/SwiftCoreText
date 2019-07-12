//
//  Font.swift
//  TypeKit
//
//  Created by Kristian Trenskow on 30/06/2019.
//  Copyright © 2019 Kristian Trenskow. All rights reserved.
//

import CoreText
import Foundation

public class Font {
    
    public enum NameKey {
        case copyright
        case family
        case subFamily
        case style
        case unique
        case full
        case version
        case postScript
        case trademark
        case manufacturer
        case designer
        case description
        case vendorURL
        case designerURL
        case license
        case licenseURL
        case sampleText
        case postScriptCID
    }
    
    public enum Orientation {
        case `default`
        case horizontal
        case vertical
    }
    
    public struct Options: OptionSet {
        
        public typealias RawValue = UInt
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        public static var preventAutoActivation = Options(rawValue: CTFontOptions.preventAutoActivation.rawValue)
        public static var preferSystemFont = Options(rawValue: CTFontOptions.preferSystemFont.rawValue)
        
    }
    
    let pointer: CTFont
    
    public init(name: String, size: CGFloat, options: Options = []) {
        self.pointer = CTFontCreateWithNameAndOptions(name as CFString, size, nil, CTFontOptions(rawValue: options.rawValue))
    }
    
    #if canImport(UIKit) || canImport(AppKit)
    public convenience init(platformFont: PlatformFont) {
        self.init(name: platformFont.fontName, size: platformFont.pointSize)
    }
    #endif
    
}

extension Font {
    
    public var ctFont: CTFont {
        return self.pointer
    }
    
}

extension Font {
    
    public var size: CGFloat {
        return CTFontGetSize(self.pointer)
    }
    
    public var matrix: CGAffineTransform {
        return CTFontGetMatrix(self.pointer)
    }
    
    public var postScriptName: String {
        return CTFontCopyPostScriptName(self.pointer) as String
    }
    
    public var familyName: String {
        return CTFontCopyFamilyName(self.pointer) as String
    }
    
    public var fullName: String {
        return CTFontCopyFullName(self.pointer) as String
    }
    
    public var displayName: String {
        return CTFontCopyDisplayName(self.pointer) as String
    }
    
    public func name(for key: NameKey) -> String? {
        return CTFontCopyName(self.pointer, key.value) as String?
    }
    
    public func localizedName(for key: NameKey) -> String? {
        return CTFontCopyLocalizedName(self.pointer, key.value, nil) as String?
    }
    
    public var characterSet: CharacterSet {
        return CTFontCopyCharacterSet(self.pointer) as CharacterSet
    }
    
    public var stringEncoding: String.Encoding? {
        switch CTFontGetStringEncoding(self.pointer) {
        case CFStringBuiltInEncodings.ASCII.rawValue:
            return .ascii
        case CFStringBuiltInEncodings.isoLatin1.rawValue:
            return .isoLatin1
        case CFStringBuiltInEncodings.macRoman.rawValue:
            return .macOSRoman
        case CFStringBuiltInEncodings.nextStepLatin.rawValue:
            return .nextstep
        case CFStringBuiltInEncodings.nonLossyASCII.rawValue:
            return .nonLossyASCII
        case CFStringBuiltInEncodings.unicode.rawValue:
            return .unicode
        case CFStringBuiltInEncodings.UTF16.rawValue:
            return .utf16
        case CFStringBuiltInEncodings.UTF16BE.rawValue:
            return .utf16BigEndian
        case CFStringBuiltInEncodings.UTF16LE.rawValue:
            return .utf16LittleEndian
        case CFStringBuiltInEncodings.UTF32.rawValue:
            return .utf32
        case CFStringBuiltInEncodings.UTF32BE.rawValue:
            return .utf32BigEndian
        case CFStringBuiltInEncodings.UTF32LE.rawValue:
            return .utf32LittleEndian
        case CFStringBuiltInEncodings.UTF8.rawValue:
            return .utf8
        case CFStringBuiltInEncodings.windowsLatin1.rawValue:
            return .windowsCP1250
        default:
            return nil
        }
    }
    
    public var ascent: CGFloat {
        return CTFontGetAscent(self.pointer)
    }
    
    public var descent: CGFloat {
        return CTFontGetDescent(self.pointer)
    }
    
    public var leading: CGFloat {
        return CTFontGetLeading(self.pointer)
    }
    
    public var lineHeight: CGFloat {
        return self.ascent + self.descent + self.leading
    }
    
    public var unitsPerEm: UInt32 {
        return CTFontGetUnitsPerEm(self.pointer)
    }
    
    public var glyphCount: Int {
        return CTFontGetGlyphCount(self.pointer)
    }
    
    public var boundingBox: CGRect {
        return CTFontGetBoundingBox(self.pointer)
    }
    
    public var underlinePosition: CGFloat {
        return CTFontGetUnderlinePosition(self.pointer)
    }
    
    public var underlineThichness: CGFloat {
        return CTFontGetUnderlineThickness(self.pointer)
    }
    
    public var slantAngle: CGFloat {
        return CTFontGetSlantAngle(self.pointer)
    }
    
    public var capHeight: CGFloat {
        return CTFontGetCapHeight(self.pointer)
    }
    
    public var xHeight: CGFloat {
        return CTFontGetXHeight(self.pointer)
    }
    
    public func path(forGlyph glyph: CGGlyph, matrix: CGAffineTransform? = nil) -> CGPath? {
        var m = matrix ?? .identity
        return CTFontCreatePathForGlyph(self.pointer, glyph, &m)
    }
    
    public func glyph(named name: String) -> CGGlyph {
        return CTFontGetGlyphWithName(self.pointer, name as CFString)
    }
    
    public func boundingRect(for glyphs: [CGGlyph], orientation: Orientation = .default) -> (overall: CGRect, individual: [CGRect]) {
        
        var g = glyphs
        var individual = [CGRect](repeating: .zero, count: g.count)
        
        let overall = CTFontGetBoundingRectsForGlyphs(self.pointer, orientation.value, &g, &individual, g.count)
        
        return (overall, individual)
        
    }
    
    public func advances(for glyphs: [CGGlyph], orientation: Orientation = .default) -> (overall: CGFloat, individual: [CGSize]) {
        
        var g = glyphs
        var individual = [CGSize](repeating: .zero, count: g.count)
        
        let overall = CTFontGetAdvancesForGlyphs(self.pointer, orientation.value, &g, &individual, g.count)
        
        return (CGFloat(overall), individual)
        
    }
    
    public func verticalTranslations(for glyphs: [CGGlyph]) -> [CGSize] {
        
        var g = glyphs
        var result = [CGSize](repeating: .zero, count: g.count)
        
        CTFontGetVerticalTranslationsForGlyphs(self.pointer, &g, &result, g.count)
        
        return result
        
    }
    
    #if canImport(UIKit) || canImport(AppKit)
    public var platformFont: PlatformFont {
        return PlatformFont(name: self.postScriptName, size: self.size)!
    }
    #endif
    
}

extension Font: Equatable {
    public static func ==(lhs: Font, rhs: Font) -> Bool {
        return lhs.pointer == rhs.pointer
    }
}

extension Font.NameKey {
    var value: CFString {
        switch self {
        case .copyright:
            return kCTFontCopyrightNameKey
        case .description:
            return kCTFontDescriptionNameKey
        case .designer:
            return kCTFontDesignerNameKey
        case .designerURL:
            return kCTFontDesignerURLNameKey
        case .family:
            return kCTFontFamilyNameKey
        case .full:
            return kCTFontFullNameKey
        case .license:
            return kCTFontLicenseNameKey
        case .licenseURL:
            return kCTFontLicenseURLNameKey
        case .manufacturer:
            return kCTFontManufacturerNameKey
        case .postScript:
            return kCTFontPostScriptNameKey
        case .postScriptCID:
            return kCTFontPostScriptCIDNameKey
        case .sampleText:
            return kCTFontSampleTextNameKey
        case .style:
            return kCTFontStyleNameKey
        case .subFamily:
            return kCTFontSubFamilyNameKey
        case .trademark:
            return kCTFontTrademarkNameKey
        case .unique:
            return kCTFontUniqueNameKey
        case .vendorURL:
            return kCTFontVendorURLNameKey
        case .version:
            return kCTFontVersionNameKey
        }
    }
}

extension Font.Orientation {
    var value: CTFontOrientation {
        switch self {
        case .default:
            return .default
        case .horizontal:
            return .horizontal
        case .vertical:
            return .vertical
        }
    }
}
