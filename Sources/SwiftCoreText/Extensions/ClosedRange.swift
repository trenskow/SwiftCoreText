//
//  Range.swift
//  TypeKit
//
//  Created by Kristian Trenskow on 30/06/2019.
//  Copyright © 2019 Kristian Trenskow. All rights reserved.
//

import Foundation

extension ClosedRange where Bound == Int {

	init(cfRange: CFRange) {
		self = ClosedRange(uncheckedBounds: (cfRange.location, cfRange.location + cfRange.length))
	}

	var cfRange: CFRange {
		return CFRangeMake(self.lowerBound, self.upperBound - self.lowerBound)
	}

}
