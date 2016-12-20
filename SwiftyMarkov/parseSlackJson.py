#!/usr/bin/python

import sys
import json

if len(sys.argv) != 2:
	print "Usage: " + sys.argv[0] + " <filename>"
	print "File should be json format"
	exit(1)

with open(sys.argv[1]) as f:
	jsonString = f.read()
	f.close()

parsed_json = json.loads(jsonString)
texts = []
for entry in parsed_json:
	if entry['text'] is not None:
		texts.append(entry['text'])

full_text = '\n'.join(texts)
file = open('slack.txt', 'a')
file.write(full_text.encode("UTF-8"))
file.close()
