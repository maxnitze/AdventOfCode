#!usr/bin/env ruby

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

bool_light_grid = Array.new(1000) { Array.new(1000, 0) }
brightness_light_grid = Array.new(1000) { Array.new(1000, 0) }

File.open(input_file, 'r') do |f|
  f.each_line do |line|
    if match = line.match(/^(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/)
    cmd, start_x, start_y, end_x, end_y = match.captures
      for x in start_x.to_i..end_x.to_i
        for y in start_y.to_i..end_y.to_i
          if cmd.eql? 'turn on'
            bool_light_grid[x][y] = 1
            brightness_light_grid[x][y] += 1
          elsif cmd.eql? 'turn off'
            bool_light_grid[x][y] = 0
            brightness_light_grid[x][y] -= 1 if brightness_light_grid[x][y] > 0
          elsif cmd.eql? 'toggle'
            bool_light_grid[x][y] = 1-bool_light_grid[x][y]
            brightness_light_grid[x][y] += 2
          end
        end
      end
    end
  end
end

lights_lit = bool_light_grid.map { |row| row.reduce(0, :+) }.reduce(0, :+)
total_brightness = brightness_light_grid.map { |row| row.reduce(0, :+) }.reduce(0, :+)

puts "'#{lights_lit}' lights are lit."
puts "The total brightness is '#{total_brightness}'."

exit 0
