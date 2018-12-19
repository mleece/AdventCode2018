# Functions for day 4 of 2018 Advent of Code

def readData(logLines):
    lines = logLines.split('\n')
    lines = sorted(lines)
    days = [] # Format: [id, (20,30), (40,45)]
    currDay = [lines[0].split('#')[1].split(' ')[0]]
    sleeping = False
    for line in lines[1:]:
        if 'begins shift' in line:
            if sleeping:
                currDay += [(sleepStart, 60)]
            sleeping = False
            days += [currDay]
            currDay = [line.split('#')[1].split(' ')[0]]
        elif 'falls' in line and not sleeping:
            sleeping = True
            sleepStart = int(line.split(':')[1][:2])
        elif 'wakes' in line and sleeping:
            sleeping = False
            sleepEnd = int(line.split(':')[1][:2])
            currDay += [(sleepStart, sleepEnd)]
    days += [currDay]
    return days
        
def sleepyGuardsSleepyMinute(logLines):
    days = readData(logLines)
    # Get the sleepiest guard
    guards = set([i[0] for i in days])
    guardMinutes = {}
    for g in guards:
        guardMinutes[g] = 0
    for day in days:
        guardMinutes[day[0]] += sum([i[1]-i[0] for i in day[1:]])
    sleepyGuard = sorted(zip(guardMinutes.values(), guardMinutes.keys()))[-1][1]

    sleepMinutes = [0]*60
    for day in days:
        if day[0] == sleepyGuard:
            for (start, end) in day[1:]:
                for i in range(start,end):
                    sleepMinutes[i] += 1
    return int(sleepyGuard) * max(range(len(sleepMinutes)), key=lambda x: sleepMinutes[x])

def mostSleepyMinute(logLines):
    days = readData(logLines)
    guards = set([i[0] for i in days])

    sleepiestMinuteCount = 0
    sleepiestMinuteIndex = 0
    guardId = 0

    for g in guards:
        sleepMinutes = [0]*60
        for day in days:
            if day[0] == g:
                for (start, end) in day[1:]:
                    for i in range(start,end):
                        sleepMinutes[i] += 1
        if max(sleepMinutes) > sleepiestMinuteCount:
            sleepiestMinuteCount = max(sleepMinutes)
            sleepiestMinuteIndex = max(range(len(sleepMinutes)), key=lambda x: sleepMinutes[x])
            guardId = int(g)
    return guardId * sleepiestMinuteIndex
