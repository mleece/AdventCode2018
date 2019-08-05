require 'csv'
require 'ostruct'

# Get and clean data
inputS = CSV.parse(File.read("day3_input.csv")
  .gsub(",", " ")
  .gsub("x", " ")
  .gsub(":", "")
  .gsub("\#", "")
  .gsub("@ ", ""),
  col_sep: " ")

input = []
inputS.each do |row|
  input << row.map(&:to_i)
end

xCoords = Array.new(input.length).map{ |n| Array.new(1, default=0)}
yCoords = Array.new(input.length).map{ |n| Array.new(1, default=0)}

def make_horizontal_lines(xCoords, input)
  input.each do |entry|
    for j in (entry[1]...entry[1]+entry[3])
      xCoords[(entry[0]-1)] << j
    end
  end
  xCoords.each do |entry|
    entry.shift
  end
end
make_horizontal_lines(xCoords, input)



def make_vertical_lines(yCoords, input)
  input.each do |entry|
    for k in (entry[2]...entry[2]+entry[4])
      yCoords[(entry[0]-1)] << k
    end
  end
  yCoords.each do |entry|
    entry.shift
  end
end
make_vertical_lines(yCoords, input)


fabric = Array.new(xCoords.flatten.max+1, default=0).map{ |x| Array.new(x, default=0) }
fabric.each do |entry|
  fabric.length.times { entry << 0 }
end

def count_coords(xCoords, yCoords, fabric)
  for n in (0...(xCoords.length))
    xCoords[n].each do |x|
      yCoords[n].each do |y|
        fabric[y][x] += 1
      end
    end
  end
end

count_coords(xCoords, yCoords, fabric)

puts "\ncount where x > 1: \n"
print fabric.flatten.count { |x| x > 1 }


counter = Array.new(input.length).map{ |n| Array.new(1, default=0)}git

def find_non_overlapped_square(xCoords, yCoords, fabric, counter)
  for n in (0...xCoords.length)
    xCoords[n].each do |x|
      yCoords[n].each do |y|
        if fabric[y][x] > 1
          counter[n][0] += 1
        end
      end
    end
  end
end
find_non_overlapped_square(xCoords, yCoords, fabric, counter)


id = counter.flatten.index(0) + 1
puts "\nid of non-overlapping entry :  \n"
print id

