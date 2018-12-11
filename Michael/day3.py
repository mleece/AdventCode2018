# Functions for Day 3 of 2018 Advent of Code

def makeFabric(rectLines):
    lines = rectLines.split('\n')
    leftTops = [i.split(' ')[2][:-1].split(',') for i in lines]
    leftTops = [(int(i[0]), int(i[1])) for i in leftTops]
    widthHeights = [i.split(' ')[-1].split('x') for i in lines]
    widthHeights = [(int(i[0]), int(i[1])) for i in widthHeights]
    maxWidth = max([leftTops[i][0] + widthHeights[i][0] for i in range(len(leftTops))])
    maxHeight = max([leftTops[i][1] + widthHeights[i][1] for i in range(len(leftTops))])

    fabric = [[0]*(maxWidth+1) for i in range(maxHeight+1)]

    for k in range(len(leftTops)):
        for i in range(leftTops[k][1], leftTops[k][1]+widthHeights[k][1]):
            for j in range(leftTops[k][0], leftTops[k][0]+widthHeights[k][0]):
                fabric[i][j] += 1

    return fabric


def countOverlap(rectLines):
    fabric = makeFabric(rectLines)

    overlapped = 0
    for i in range(len(fabric)):
        for j in range(len(fabric[0])):
            if fabric[i][j] > 1:
                overlapped += 1
    return overlapped




def findClear(rectLines):
    fabric = makeFabric(rectLines)
    
    lines = rectLines.split('\n')
    leftTops = [i.split(' ')[2][:-1].split(',') for i in lines]
    leftTops = [(int(i[0]), int(i[1])) for i in leftTops]
    widthHeights = [i.split(' ')[-1].split('x') for i in lines]
    widthHeights = [(int(i[0]), int(i[1])) for i in widthHeights]

    for k in range(len(leftTops)):
        clear = True
        for i in range(leftTops[k][1], leftTops[k][1]+widthHeights[k][1]):
            for j in range(leftTops[k][0], leftTops[k][0]+widthHeights[k][0]):
                if fabric[i][j] > 1:
                    clear = False
                    break
            if clear == False:
                break
        if clear:
            return lines[k].split(' ')[0][1:]
        
