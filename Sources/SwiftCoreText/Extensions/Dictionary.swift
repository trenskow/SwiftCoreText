//
//  Dictionary.swift
//  Render
//
//  Created by Kristian Trenskow on 30/06/2019.
//  Copyright © 2019 Kristian Trenskow. All rights reserved.
//

import Foundation

extension Dictionary {
    static func +(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.keys.forEach { result[$0] = rhs[$0] }
        return result
    }
}
