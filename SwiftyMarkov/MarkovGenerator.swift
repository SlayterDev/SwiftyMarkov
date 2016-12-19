//
//  MarkovGenerator.swift
//  SwiftyMarkov
//
//  Created by Bradley Slayter on 12/18/16.
//  Copyright © 2016 Flipped Bit. All rights reserved.
//

import Cocoa

class MarkovGenerator: NSObject {
	var order = 6
	var grams = [String:[String]]()
	
	var capitalGrams: [(key: String, value: [String])]?
	
	init(order: Int) {
		super.init()
		
		self.order = order
	}
	
	func analyzeNgrams(text: String) {
		let utfText = Array(text.unicodeScalars)
		
		guard utfText.count > order else { return }
		
		for i in 0..<utfText.count - order {
			let gram = utfText[i..<i+order].map { String($0) }.joined(separator: "")
			
			if grams[gram] == nil {
				// Create new array if gram doesn't exist in table
				grams[gram] = []
			}
			
			// Add next char after gram to the table
			grams[gram]?.append(String(describing: utfText[i + order]))
		}
	}
	
	func getCapitalGram() -> String? {
		if capitalGrams == nil {
			capitalGrams = grams.filter { $0.key.characters.first!.isUppercase }
		}
		
		guard capitalGrams!.count > 0 else { return nil }
		
		return capitalGrams?.randomChoice().key
	}
	
	func generateText(length: Int, tryForSentence: Bool, startWithCapital: Bool = true) -> String {
		var currentGram: String?
		
		// get our first gram
		if startWithCapital {
			if let gram = getCapitalGram() {
				currentGram = gram
			} else {
				print("Could not start sentence")
				return ""
			}
		} else {
			currentGram = Array(grams.keys).randomChoice()
		}
		
		var result = currentGram!
		
		for _ in 0..<length-order {
			guard let possibilites = grams[currentGram!] else { continue }
			let next = possibilites.randomChoice()
			result += next
			
			currentGram = result[(result.length - order)..<result.length]
			
			if tryForSentence && result[result.length - 1] == "." {
				break
			}
		}
		
		return result
	}
}
