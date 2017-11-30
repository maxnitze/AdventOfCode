#!usr/bin/env ruby

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

cur_floor = 0
first_to_basement = -1

File.open(input_file, 'r') do |f|
  f.each_char.with_index(1) do |c, i|
    cur_floor += 1 if c.eql? '('
    cur_floor -= 1 if c.eql? ')'

    first_to_basement = i if cur_floor < 0 && first_to_basement == -1
  end
end

puts "The instructions take Santa to floor '#{cur_floor}'."
puts "Santa enters the basement first at position '#{first_to_basement}'"

exit 0
