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

	/// Initialize a new `MarkovGenerator` object with the specified order.
	///
	/// - parameter order: The number of characters that will be considered at a time.
	///
	/// - returns: A new `MarkovGenerator` object
	init(order: Int) {
		super.init()
		
		self.order = order
	}
	
	/// Loop over the text and add all ngrams and the following character to the `grams` table.
	///
	/// - parameter text: The text to be analyzed.
	func analyzeNgrams(text: String) {
		// Convert the String to an array of unicode scalars because Swift's native string indexing
		// methods are shit when it comes to dealing with large amounts of text.
		let utfText = Array(text.unicodeScalars)
		
		guard utfText.count > order else { return }
		
		for i in 0..<utfText.count - order {
			// Grab the gram of the specified length and convert it back to a Swift String
			let gram = utfText[i..<i+order].map { String($0) }.joined(separator: "")
			
			if grams[gram] == nil {
				// Create new array if gram doesn't exist in table
				grams[gram] = []
			}
			
			// Add next char after gram to the table
			grams[gram]?.append(String(utfText[i + order]))
		}
	}
	
	/// Find all ngrams starting with a capital letter and return a random choice. If new text is added
	/// to the grams tabel after generating text, `capitalGrams` should be set to `nil` to rebuild the
	/// capital table.
	///
	/// - returns: A `String` containing a random ngram starting with a captial letter or `nil`.
	private func getCapitalGram() -> String? {
		if capitalGrams == nil {
			capitalGrams = grams.filter { $0.key.characters.first!.isUppercase }
		}
		
		guard capitalGrams!.count > 0 else { return nil }
		
		return capitalGrams?.randomChoice().key
	}
	
	/// Generate a piece of text based on the `grams` table and the specified order.
	///
	/// - parameter length:           Max length of text to be generated.
	/// - parameter tryForSentence:   Set to `true` if you want the function to try and make a
	///                               complete sentence. It will return when a period is met.
	/// - parameter startWithCapital: Defaults to `true`. Determines if the generated text should
	///                               start with a capital letter.
	///
	/// - returns: A `String` of the generated text.
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
