

def buildMatrix(coordLines):
    coords = [(int(i.split(',')[0])+1, int(i.split(',')[1])+1) for i in coordLines.split('\n')]
    maxX = max([i[0] for i in coords])
    maxY = max([i[1] for i in coords])

    grid = [[0]*(maxX+1) for i in range(maxY+1)]
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            minDist = maxX+maxY
            minIndex = 0
            for k in range(len(coords)):
                if abs(j - coords[k][0]) + abs(i - coords[k][1]) < minDist:
                    minIndex = k+1
                    minDist = abs(j - coords[k][0]) + abs(i - coords[k][1])
                elif abs(j - coords[k][0]) + abs(i - coords[k][1]) == minDist:
                    minIndex = 0
            grid[i][j] = minIndex

    return grid

def largestRegion(coordLines):
    grid = buildMatrix(coordLines)

    invalidSymbols = set([0])
    for i in range(len(grid)):
        invalidSymbols.add(grid[i][0])
        invalidSymbols.add(grid[i][-1])
    for i in range(len(grid[0])):
        invalidSymbols.add(grid[0][i])
        invalidSymbols.add(grid[-1][i])

    counts = {}
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            try:
                counts[grid[i][j]] += 1
            except:
                counts[grid[i][j]] = 1

    sortedCounts = sorted(zip(counts.values(), counts.keys()))
    sortedCounts.reverse()
    for i in sortedCounts:
        if i[1] not in invalidSymbols:
            return i[0]
            
    
def centralZoneSize(coordLines, distance):
    coords = [(int(i.split(',')[0])+1, int(i.split(',')[1])+1) for i in coordLines.split('\n')]
    maxX = max([i[0] for i in coords])
    maxY = max([i[1] for i in coords])

    grid = [[0]*(maxX+1) for i in range(maxY+1)]

    count = 0
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            totalDist = 0
            for k in range(len(coords)):
                totalDist += abs(j - coords[k][0]) + abs(i - coords[k][1])
            if totalDist < distance:
                count += 1
                if i == 0 or j == 0 or i == len(grid)-1 or j == len(grid[0])-1:
                    print 'Watch out!'
    return count

    
