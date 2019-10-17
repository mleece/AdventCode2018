require 'csv'

input = CSV.parse(File.read("day6_input.csv"),  # day6_input.csv
            col_sep: ", ")
            .map { |coordinates| coordinates.map(&:to_i) }
# puts "\ninput\n"; print input
# puts "\n\ninput length\n"; print input.length

transposed_input = input.transpose.dup; # puts "\n\ntransposed_input\n"; print transposed_input
x_coordinates = transposed_input[0].dup; # puts "\n\nx_coordinates\n"; print x_coordinates
y_coordinates = transposed_input[1].dup; # puts "\n\ny coordinates\n"; print y_coordinates

grid = {} # grid[[x, y]] = [x, y] || " . "
# create coordinate system includes a point for every origin point
# grid is a hash where each key is an array of x,y coordinates
#   the value for each key will be the coordinates of the
#   origin point that claims it or some disputed status
# grid[[x, y]] = [x, y] || "disputed"
def build_grid_and_claims(input, x_coordinates, y_coordinates, grid)    
  for j in (x_coordinates.min..x_coordinates.max)
    for k in (y_coordinates.min..y_coordinates.max)
        # distance calculated easily because Manhattan distance
        # use i and input transposed to calc distances from every 
        distances = []
        for i in (0...x_coordinates.length)
          distances << (x_coordinates[i]-j).abs + (y_coordinates[i]-k).abs
        end
        # arr.find_index(distance.min) == arr.rindex(distance.min) checks if one min dist
        # set grid entry : grid[[x, y]] = [origin_x, origin_y] || " . "
        if distances.find_index(distances.min) == distances.rindex(distances.min)
        grid[[j, k]] = input[distances.find_index(distances.min)].dup
      else
        grid[[j, k]] = " . "
      end
    end
  end
  # puts "\ngrid\n"
  # grid.each { |coord, claim| puts "#{coord} claimed by #{claim}" }
  puts "\ngrid length"; print grid.length
end
build_grid_and_claims(input, x_coordinates, y_coordinates, grid)

box = {}
def build_box_and_claims(x_coordinates, y_coordinates, grid, box)
  for j in (x_coordinates.min..x_coordinates.max)
    box[[j, y_coordinates.min]] = grid[[j, y_coordinates.min]]
    box[[j, y_coordinates.max]] = grid[[j, y_coordinates.max]]
    j += 1
  end
  for k in ((y_coordinates.min+1)..(y_coordinates.max-1))
    box[[x_coordinates.min, k]] = grid[[x_coordinates.min, k]]
    box[[x_coordinates.max, k]] = grid[[x_coordinates.max, k]]
    k += 1
  end
  # puts "\n\nbox\n"
  # box.each { |coord, claim| puts "#{coord} claimed by #{claim}" }
  puts "\nbox length"; print box.length
end
build_box_and_claims(x_coordinates, y_coordinates, grid, box)

grid_claims_counter = [] # indexed to input entries, count of claims
box_claims_counter = [] # indexed to input entries, count of claims
def count_claims(input, coords_claims_hash, origin_counter)
  # counts number of coordinates
  for i in (0...input.length)
    count = 0
    origin_point = input[i].dup
    coords_claims_hash.each { |coordinate, claim| count += 1 unless claim != origin_point }
    origin_counter << count
  end 
  puts "counter\n"; print origin_counter; puts "\n"
end
puts "\ngrid count_claims"; count_claims(input, grid, grid_claims_counter)
puts "\nbox count_claims"; count_claims(input, box, box_claims_counter)

def greatest_area_origin_not_infinite(input, grid_claims_counter, box_claims_counter)
  #
  enclosed_origins_i = []
  box_claims_counter.each_index { |i| enclosed_origins_i << i unless box_claims_counter[i] > 0 }
  enclosed_origin_areas = []
  enclosed_origins_i.each { |i| enclosed_origin_areas << grid_claims_counter[i] }
  puts "\nhighest enclosed area\n"; print enclosed_origin_areas.max; puts "\n"
end
greatest_area_origin_not_infinite(input, grid_claims_counter, box_claims_counter)

# ========================================== Part 2 ==========================================

# find total number of points for which the sum of the distances from that point to all
# origin points is less than 1000.
# Can build grid2 in the same way as before.

grid2 = {} # grid[[x, y]] = "#"" || "."
def build_grid2_measure_distances(input, x_coordinates, y_coordinates, grid2)
  for j in (x_coordinates.min..x_coordinates.max)
    for k in (y_coordinates.min..y_coordinates.max)
      distances = []
        for i in (0...x_coordinates.length)
          distances << (x_coordinates[i]-j).abs + (y_coordinates[i]-k).abs
        end
        if distances.sum < 10000
          grid2[[j, k]] = "#"
        else
          grid2[[j, k]] = "."
      end
    end
  end
  # puts "\ngrid2\n"; grid2.each { |coord, claim| puts "#{coord} claimed by #{claim}" }
  # puts "\ngrid2 length"; print grid2.length
  safe_counter = 0
  grid2.each_value { |mark| safe_counter += 1 unless mark != "#"}
  puts "\nsafe counter\n"; print safe_counter; puts "\n"
end
build_grid2_measure_distances(input, x_coordinates, y_coordinates, grid2)
