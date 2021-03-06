//
//  StringExtensions.swift
//  SwiftyMarkov
//
//  Created by Bradley Slayter on 12/18/16.
//  Copyright © 2016 Flipped Bit. All rights reserved.
//

import Cocoa

extension String {
	var length: Int {
		return self.characters.count
	}
	
	subscript (i: Int) -> String {
		return self[Range(i ..< i + 1)]
	}
	
	func substring(from: Int) -> String {
		return self[Range(min(from, length) ..< length)]
	}
	
	func substring(to: Int) -> String {
		return self[Range(0 ..< max(0, to))]
	}
	
	subscript (r: Range<Int>) -> String {
		let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
		                                    upper: min(length, max(0, r.upperBound))))
		let start = index(startIndex, offsetBy: range.lowerBound)
		let end = index(start, offsetBy: range.upperBound - range.lowerBound)
		return self[Range(start ..< end)]
	}
	
	func isUppercased(at: Index) -> Bool {
		let range = at..<self.index(after: at)
		return self.rangeOfCharacter(from: .uppercaseLetters, options: [], range: range) != nil
	}
}

extension Character {
	var isUppercase: Bool {
		let str = String(self)
		return str.isUppercased(at: str.startIndex)
	}
}
