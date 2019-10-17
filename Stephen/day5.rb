puts "\nhi\n"
input = ""
IO.foreach("day5_input.txt") { |x| input << x }
# "LlspxXPjJMmBbVvyYNnzLlZFfSTtULRlLrTtbBlaAJjqQUuXxQnWwNqIi"
i = 0
current_string = input.dup
# finds and eliminates reacting monomers
# doesn't back-react
def reactions!(i, current_string)
  i = 0
  while i < (current_string.length-1) do
    if current_string[i].capitalize == current_string[i+1].capitalize && current_string[i] != current_string[i+1]
      current_string.slice!(i..(i+1))
    #elsif current_string[i-1].capitalize == current_string[i].capitalize && current_string[i] != current_string[i-1]
    #  current_string.slice!((i-1)..i)
    #  i -= 1
    else
      i += 1
    end
  end
end
# reactions!(i, current_string)

# performs successive reactions until no eliminations are made
def equilibrate!(i, current_string)
  length_before = 0
  length_after = current_string.length
  while length_before != length_after
    length_before = current_string.length
    reactions!(i, current_string)
    length_after = current_string.length
    #puts "\n------length before : length after------\n"
    #print length_before, " : ", length_after
  end
  puts "\nequilibrium length\n"
  print current_string.length
end
equilibrate!(i, current_string)

# Part 2
# Removes both polarities of one monomer then equilibrates. 
# Repeats for all monomer types.
# Creates list of the lengths of the results of those final states.
monomer_types = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
monomer_removed_equilibriums = []
def remove_monomer_equilibrate(input, i, current_string, monomer_types, monomer_removed_equilibriums)  
  monomer_types.each do |monomer|
    i = 0
    current_string = input.dup
    polarity1 = monomer
    polarity2 = monomer.capitalize
    current_string.delete!(polarity1)
    current_string.delete!(polarity2)
    equilibrate!(i, current_string)
    monomer_removed_equilibriums << current_string.length
  end
  puts "\nmonomer types\n"
  print monomer_types
  puts "\nmonomer removed equilibriums\n"
  print monomer_removed_equilibriums
  puts "\nlowest equilibrium\n"
  print monomer_removed_equilibriums.min
end
remove_monomer_equilibrate(input, i, current_string, monomer_types, monomer_removed_equilibriums)
