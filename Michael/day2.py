# Functions for Day 2 of 2018 Advent of Code

def letterCounts(word):
    counts = {}
    for letter in word:
        try:
            counts[letter] += 1
        except:
            counts[letter] = 1
    return counts

def letterChecksum(idsStr):
    ids = idsStr.split('\n')
    pairCount = 0
    tripleCount = 0
    for word in ids:
        counts = letterCounts(word)
        if 2 in counts.values():
            pairCount += 1
        if 3 in counts.values():
            tripleCount += 1
    return pairCount * tripleCount


###

def findMatching(idsStr):
    ''' There's probably something clever here with the checksum, but
        simple brute force first '''
    ids = idsStr.split('\n')
    for i in range(len(ids)-1):
        for j in range(i+1, len(ids)):
            if wordsMatch(ids[i],ids[j]):
                for k in range(len(ids[i])):
                    if ids[i][k] != ids[j][k]:
                        return ids[i][:k] + ids[i][k+1:]

def wordsMatch(a, b):
    diffCharFound = False
    for i in range(len(a)):
        if a[i] != b[i]:
            if diffCharFound:
                return False
            diffCharFound = True
    return True
            
    
