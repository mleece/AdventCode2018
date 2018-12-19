# Functions for day 5 of 2018 Advent of Code

def compressPolymer(polymerStr):
    oldStr = polymerStr
    while True:
        i = 0
        newStr = ''
        while i < len(oldStr)-1:
            if abs(ord(oldStr[i]) - ord(oldStr[i+1])) == 32:
                i += 2
            else:
                newStr += oldStr[i]
                i += 1
        if i == len(oldStr)-1:
            newStr += oldStr[i]
        if len(oldStr) == len(newStr):
            break
        oldStr = newStr
    return newStr

def bestRemoval(polymerStr):
    chars = set(list(polymerStr))
    lowerChars = [c for c in chars if ord(c) >= 97]

    bestCompression = len(polymerStr)

    for char in lowerChars:
        newStr = polymerStr.replace(char,'').replace(chr(ord(char)-32),'')
        newCompression = len(compressPolymer(newStr))
        bestCompression = min(bestCompression, newCompression)
    return bestCompression
