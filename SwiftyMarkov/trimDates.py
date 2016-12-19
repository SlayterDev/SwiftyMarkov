#!/usr/bin/python

with open('donald.txt') as f:
	lines = f.readlines()

	trimmedLines = []
	for line in lines:
		trimmedLines.append(line[:-13])

	result = '\n'.join(trimmedLines)

	f.close()

f = open('donald.txt', 'w')
f.write(result + '\n')
f.close()
