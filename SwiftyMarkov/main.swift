//
//  main.swift
//  SwiftyMarkov
//
//  Created by Bradley Slayter on 12/18/16.
//  Copyright © 2016 Flipped Bit. All rights reserved.
//

import Foundation


func showNotification(title: String, text: String) -> Void {
	let notification = NSUserNotification()
	notification.title = title
	notification.informativeText = text
	notification.soundName = NSUserNotificationDefaultSoundName
	
	NSUserNotificationCenter.default.deliver(notification)
}

let bundle = Bundle.main
var content: String?
do {
	content = try String(contentsOf: URL(string: "file://<your-file-here>")!, encoding: String.Encoding.utf8)
} catch let error as NSError {
	print("Could not open file: \(error.localizedDescription)")
	exit(1)
}

let paragraphs = content?.components(separatedBy: "\n")

let markov = MarkovGenerator(order: 6)

for (i, text) in paragraphs!.enumerated() {
	markov.analyzeNgrams(text: text)
}

let uniqueGrams = markov.grams.filter { $0.value.count == 1 }

print("Unique grams: \(uniqueGrams.count)/\(markov.grams.count)\n")

for _ in 0..<10 {
	print(markov.generateText(length: 140, tryForSentence: false, startWithCapital: true))
	print()
}

showNotification(title: "All Done!", text: "Check the console!")
