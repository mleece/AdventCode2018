# Functions for Day 1 of 2018 Advent of Code

def frequencyChange(changeStr):
    changes = [int(x) for x in changeStr.split('\n')]
    return sum(changes)

def firstRepeatedFrequency(changeStr):
    changes = [int(x) for x in changeStr.split('\n')]
    curFreq = 0
    seenFreqs = set()
    i = 0
    while curFreq not in seenFreqs:
        seenFreqs.add(curFreq)
        curFreq = curFreq + changes[i]
        i = (i+1)%len(changes)
    return curFreq
