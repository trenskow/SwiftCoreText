//
//  Platform.swift
//
//
//  Created by Kristian Trenskow on 12/07/2019.
//

import Foundation

#if canImport(UIKit)
import UIKit
public typealias PlatformFont = UIFont
#elseif canImport(AppKit)
import AppKit
public typealias PlatformFont = NSFont
#endif
