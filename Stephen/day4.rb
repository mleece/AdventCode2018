require 'csv'
require 'set'

input_string = CSV.parse(File.read("day4_input.csv")
                 .gsub("-", " ")
                 .gsub(":", " ")
                 .gsub("\#", "")
                 .gsub("[", "")
                 .gsub("]", ""),
                  col_sep: " ")

# Convert
input_string.each do |row|
  strs = row[0..20]
  nums = strs.map(&:to_i)
  row.shift(1)
  row = nums + row
end
# Sort
sorted_input = input_string.sort_by { |row| [row[0], row[1], row[2], row[3]] }
input = sorted_input
  .map { |row| [row[0].to_i, row[1].to_i, row[2].to_i, row[3].to_i, row[4], row[5]] }

# We want day/minute asleep info for each Guard
# Use a list, entry for each day/guard
# shifts format: [ID, [month, day], [start, stop], [start, stop]]
shifts = []
def generate_shift_sleep_ranges(input, shifts)
  current_shift = []
  for entry in input
    if entry[4] == "Guard"
      shifts << current_shift
      current_shift = []
      current_shift[0] = entry[-1].to_i
    elsif entry[4] == "falls"
      current_shift << [entry[0],entry[1]]
      current_shift << [entry[3]]
    elsif entry[4] == "wakes"
      current_shift[-1] << entry[3]
    end
  end
  shifts << current_shift
  shifts.shift(1)
end
generate_shift_sleep_ranges(input, shifts)

guards = [] # Set of guards
def find_guards(shifts, guards)
  ids = []
  for shift in shifts
    ids << shift[0]
  end
  guards << Set.new(ids).to_a
  guards.flatten!
end
find_guards(shifts, guards)


sleep_minutes = {} # { guard => [array of minutes slept counts]}
guards.each do |guard|
  sleep_minutes[guard] = [0]*60
end

# count recurrence of sleep by min index (1-60)
def count_minutes(shifts, guards, sleep_minutes)
  guards.each do |guard|
    shifts.each do |shift|
      if shift[0] == guard
        min_ranges_indexes = (2...shift.length).to_a
        min_ranges_indexes.each do |index|
          minutes = (shift[index][0]...shift[index][1]).to_a
          minutes.each do |minute|
            sleep_minutes[guard][minute-1] += 1
          end
        end
      end
    end
  end
end
count_minutes(shifts, guards, sleep_minutes)


sleepiest_guard = 0
minutes_asleep = 0
def find_sleepiest_guard(sleep_minutes, guards, sleepiest_guard, minutes_asleep)
  guards.each do |guard|
    if sleep_minutes[guard].sum > minutes_asleep
      minutes_asleep = sleep_minutes[guard].sum
      sleepiest_guard = guard
    end
  end
  puts "\nsleepiest guard: \n"
  print sleepiest_guard
end
find_sleepiest_guard(sleep_minutes,guards,sleepiest_guard,minutes_asleep)

sleepiest_minute = 0
g = 1871
def find_sleepiest_minute(sleep_minutes, g)
  max = 0
  for i in (0..59)
    if sleep_minutes[g][i] > max
      max = sleep_minutes[g][i]
      puts "\nminute:"
      print i+1
    end
  end
end
find_sleepiest_minute(sleep_minutes, g)



most_slept_minute = 0
most_slept_minute_times = 0
most_consistent_guard = 0
def find_most_slept_minute(
  guards, sleep_minutes, most_slept_minute, most_slept_minute_times, most_consistent_guard)
  print "hi"
  guards.each do |guard|
    if sleep_minutes[guard].max > most_slept_minute_times
      most_slept_minute_times = sleep_minutes[guard].max
      most_consistent_guard = guard
      puts "\n" + most_slept_minute_times.to_s + "\n" 
      print "\n" + most_consistent_guard.to_s + "\n"
    end
  end
end

#find_most_slept_minute(guards, sleep_minutes, most_slept_minute, most_slept_minute_times, most_consistent_guard)
#find_sleepiest_minute(sleep_minutes, g)
