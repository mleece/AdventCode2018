input = []
line_num=0
text=File.open('day7_input.txt').read
text.gsub!(/\r\n?/, "\n")
text.each_line do |line|
  input << [line[5], line[-13]]
end
# puts "\ninput\n"; input.each { |row| print row; puts "\n" }

steps = input.dup.flatten.uniq; puts "\n\nsteps\n"; print steps; puts "\n\nsteps length\n"; print steps.length

first_steps = priors.difference(afters).uniq; puts "\n\nfirst step(s)\n"; print first_steps
last_step = afters.difference(priors).uniq; puts "\n\nlast step\n"; print last_step

parents = Array.new(steps.length).map{ |n| Array.new()}
children = Array.new(steps.length).map{ |n| Array.new()}

steps.each do |step|
  for i in (0...input.length)
    parent_of_child = input[i][0].dup
    child_of_parent = input[i][1].dup
    parent_steps_i = steps.find_index(parent_of_child)
    child_steps_i = steps.find_index(child_of_parent)
    children[parent_steps_i] << child_of_parent
    parents[child_steps_i] << parent_of_child
  end
  children.each { |step| step.uniq! }
  parents.each { |step| step.uniq! }
end
puts "\n\nparents\n"; print parents; puts "\nparents length\n"; print parents.length
puts "\n\nchildren\n"; print children; puts "\nchildren length\n"; print children.length

first_step_indexes = []
first_steps.each do |step|
  first_step_indexes << steps.find_index(step)
end
puts "\n\nfirst_step_indexes\n"; print first_step_indexes 
all_paths = []

def generate_branches_recursively(steps, children, last_step, all_paths, step_index)
  # all_paths has two steps in each path, step_index is step of second step, 
  # we want to add paths to all_paths for each child of this child (duplicating the progress thus far)
  # for each of those children: check if they are last_step[0], if not, call method on them too
  current_branch_base = all_paths[-1].dup
  current_branch_base << ""
  children[step_index].each do |child_step|
    current_branch_base.pop
    current_branch_base << child_step
    all_paths << current_branch_base.dup
    if child_step == last_step[0]
      next 
    else
      step_index = steps.find_index(child_step).dup
      generate_branches_recursively(steps, children, last_step, all_paths, step_index)
    end 
  end
end

def create_paths(steps, parents, children, first_step_indexes, last_step, all_paths)
  # work from starting points, create new paths for all children of each node
  # use generate_branches_recursively to build paths and add them to all_paths
  first_step_indexes.each do |first_step_index|
    # add a path with first_step and each of the children of the first step
    children[first_step_index].each do |child_step|
      # for each child of each first_step, enter branch generation unless last_step reached
      all_paths << [steps[first_step_index], child_step]
      if child_step == last_step[0]
        next
      else
        step_index = steps.find_index(child_step).dup
        generate_branches_recursively(steps, children, last_step, all_paths, step_index)
      end
    end
    # puts "\nall_paths\n"; print all_paths
  end
  all_paths.delete_if { |path| path[-1] != last_step[0] }
  # puts "\nall_paths\n"; print all_paths
end
create_paths(steps, parents, children, first_step_indexes, last_step, all_paths)

def show_paths(all_paths)
  puts "\n\nshow_paths"
  all_paths.each do |path|
    puts "\n"; print path
  end
end
# show_paths(all_paths)

def find_available_steps(remaining_paths_steps, step_order, available_steps)
  # returns alphabetized list of steps that can be taken next 
  remaining_paths_steps_first = []; remaining_paths_steps_subsequent = []  
  remaining_paths_steps.each do |path|
    remaining_paths_steps_first << path[0]
    remaining_paths_steps_subsequent << path[1..] unless path.length < 2
  end
  remaining_paths_steps_first.uniq!; remaining_paths_steps_first.sort!
  remaining_paths_steps_first.each do |path_first_step|
    # remove any steps that exist subsequently on different paths
    available_steps << path_first_step unless remaining_paths_steps_subsequent.flatten.include? path_first_step
  end
end

def remove_step_from_paths(step_remove, remaining_paths_steps)
  # removes a step from remaining_paths_steps
  remaining_paths_steps.map! { |path| path -= [step_remove] } 
end

step_order_alphabetical = ""
def order_steps_alphabetically(steps, last_step, all_paths, step_order_alphabetical)
  remaining_paths_steps = all_paths.dup
  while step_order_alphabetical[-1] != last_step[0]
    available_steps= []
    find_available_steps(remaining_paths_steps, step_order_alphabetical, available_steps)
    step_order_alphabetical << available_steps[0].dup
    most_recent_step_added = step_order_alphabetical[-1]
    remove_step_from_paths(most_recent_step_added, remaining_paths_steps)
  end
  puts "\n\nstep order alphabetical\n"; print step_order_alphabetical
end
order_steps_alphabetically(steps, last_step, all_paths, step_order_alphabetical)


def remove_steps_in_progress_or_completed(steps, steps_completion_times, available_steps)
  # remove any steps from available steps that has a non zero steps_completion_times
  in_progress_or_completed_steps = []
  steps.each_index do |i|
    if steps_completion_times[i] != 0
      in_progress_or_completed_steps << steps[i]
    end
  end
  @available_steps = available_steps - in_progress_or_completed_steps
end

step_order = ""
available_workers = 5
def order_steps_with_duration(steps, last_step, all_paths, step_order, available_workers)
  # I think the problem is suggesting that the next selected step to perform should
  # still be the next available, highest alphabetically, step. So I'll assume that.
  remaining_paths_steps = all_paths.dup
  alphabet = 'A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z'.split(',')
  step_durations = []
  steps.each do |step|
    step_durations << 61 + alphabet.find_index(step)
  end
  seconds = 0
  steps_completion_times = [0]*steps.length # indexed to steps array
  available_steps = []
  
  while step_order[-1] != last_step[0] 
    if available_workers > 0 && steps_completion_times.include?(0)
      available_steps = []
      find_available_steps(remaining_paths_steps, step_order, available_steps)
      remove_steps_in_progress_or_completed(steps, steps_completion_times, available_steps)
      available_workers.times do |start_next_available_steps_for_duration_seconds|
        # assumption that steps are chosen alphabetically from all available steps
        # check that next available step is not currently started
        #   if so, go down available steps list
        #     start next available step, 
        #     set step_completion_time
        #     decrement available_workers
        # else 
        #   next (don't decrement available_workers)
        if @available_steps.length > 0 
          step_to_start_index = steps.find_index(@available_steps[0].dup)
          steps_completion_times[step_to_start_index] = seconds + step_durations[step_to_start_index]
          @available_steps.shift
          available_workers -= 1; # puts "\navailable_workers\n"; print available_workers
        else
          next
        end
      end
      seconds += 1; puts "\nseconds\n"; print seconds
    else
      seconds += 1; puts "\nseconds\n"; print seconds
    end
    # check if any steps completed, add them to order, increment available_workers
    # what if two steps end on the same second????? 
    temporary_steps = []
    steps_completion_times.map.with_index do |completion_time, i|
      if seconds == completion_time
        temporary_steps << steps[i]
        available_workers += 1; puts "\navailable_workers\n"; print available_workers
      end
    end  
    temporary_steps.sort!; temporary_steps.uniq!
    temporary_steps.each do |step|
      step_order << step
      remove_step_from_paths(step, remaining_paths_steps)
    end
  end
  puts "\nstep_order\n"; print step_order
  puts "\nseconds\n"; print seconds
end
order_steps_with_duration(steps, last_step, all_paths, step_order, available_workers)
