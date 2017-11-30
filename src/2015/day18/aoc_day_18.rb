#!usr/bin/env ruby

def get_adjacent_sum grid, row, col
  [[-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1]].map { |pos|
    grid[[row+pos[0], col+pos[1]]] || 0
  }.reduce(0) { |sum, state| sum + state }
end

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

steps = 100

@array_size = 100
grid_edges = [[0, 0], [0, @array_size-1], [@array_size-1, @array_size-1], [@array_size-1, 0]]

grid = {}

File.open(input_file, 'r') do |f|
  f.readlines.map(&:chomp).each_with_index do |line, row|
    line.each_char.with_index do |c, col|
      grid[[row, col]] = c == '#' ? 1 : 0
    end
  end
end

grid_1 = grid.clone
grid_2 = grid.clone
grid_edges.each do |pos|
  grid_2[pos] = 1
end

steps.times do
  new_grid_1 = {}
  new_grid_2 = {}

  for row in 0..@array_size-1
    for col in 0..@array_size-1
      if grid_1[[row, col]] == 0
        new_grid_1[[row, col]] = get_adjacent_sum(grid_1, row, col) == 3 ? 1 : 0
      else
        new_grid_1[[row, col]] = [2, 3].include?(get_adjacent_sum(grid_1, row, col)) ? 1 : 0
      end

      if grid_edges.include? [row, col]
        new_grid_2[[row, col]] = 1
      elsif grid_2[[row, col]] == 0
        new_grid_2[[row, col]] = get_adjacent_sum(grid_2, row, col) == 3 ? 1 : 0
      else
        new_grid_2[[row, col]] = [2, 3].include?(get_adjacent_sum(grid_2, row, col)) ? 1 : 0
      end
    end
  end

  grid_1 = new_grid_1
  grid_2 = new_grid_2
end

puts "After '#{steps}' steps '#{grid_1.reduce(0) { |s, l| s + l.last }}' lights are lit."
puts "In the grid with the four stuck lights after '#{steps}' steps '#{grid_2.reduce(0) { |s, l| s + l.last }}' lights are lit."

exit 0
