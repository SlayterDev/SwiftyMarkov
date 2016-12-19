#!/usr/bin/python

import json

filename = raw_input("Enter input file> ")

with open(filename) as f:
	jsonString = f.read()
	f.close()

parsed_json = json.loads(jsonString)
texts = []
for entry in parsed_json:
	if entry['text'] is not None:
		texts.append(entry['text'])

full_text = '\n'.join(texts)
file = open('slack.txt', 'w')
file.write(full_text.encode("UTF-8"))
file.close()
