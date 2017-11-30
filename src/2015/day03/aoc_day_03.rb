#!usr/bin/env ruby

require 'set'

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

this_year = Set.new
next_year = Set.new

this_year_santa_x = 0
this_year_santa_y = 0

next_year_santa_x = 0
next_year_santa_y = 0
next_year_robot_x = 0
next_year_robot_y = 0

this_year << [this_year_santa_x, this_year_santa_y]
next_year << [next_year_santa_x, next_year_santa_y]

File.open(input_file, 'r') do |f|
  f.each_char.with_index do |c, i|
    if c == '^'
      this_year_santa_y += 1
      next_year_santa_y += 1 if i%2 == 0
      next_year_robot_y += 1 if i%2 != 0
    elsif c == 'v'
      this_year_santa_y -= 1
      next_year_santa_y -= 1 if i%2 == 0
      next_year_robot_y -= 1 if i%2 != 0
    elsif c == '<'
      this_year_santa_x -= 1
      next_year_santa_x -= 1 if i%2 == 0
      next_year_robot_x -= 1 if i%2 != 0
    elsif c == '>'
      this_year_santa_x += 1
      next_year_santa_x += 1 if i%2 == 0
      next_year_robot_x += 1 if i%2 != 0
    end

    this_year << [this_year_santa_x, this_year_santa_y]
    next_year << [next_year_santa_x, next_year_santa_y] if i%2 == 0
    next_year << [next_year_robot_x, next_year_robot_y] if i%2 != 0
  end
end

puts "#{this_year.size} houses received at least one preset the first year"
puts "#{next_year.size} houses received at least one preset the second year"

exit 0
