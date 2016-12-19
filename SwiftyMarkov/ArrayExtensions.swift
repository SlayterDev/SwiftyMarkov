//
//  ArrayExtensions.swift
//  SwiftyMarkov
//
//  Created by Bradley Slayter on 12/18/16.
//  Copyright © 2016 Flipped Bit. All rights reserved.
//

import Cocoa

extension Array {
	func randomChoice() -> Element {
		let index = Int(arc4random()) % self.count
		return self[index]
	}
}
