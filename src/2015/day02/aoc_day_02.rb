#!usr/bin/env ruby

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

paper_surface = 0
ribbon_length = 0

File.open(input_file, 'r') do |f|
  f.each_line do |line|
    if match = line.match(/^(\d+)x(\d+)x(\d+)/i)
      length, width, height = match.captures.map { |c| c.to_i }
      first_dim, second_dim, _ = [length, width, height].sort

      paper_surface += 2*length*width + 2*width*height + 2*height*length + first_dim*second_dim
      ribbon_length += 2*first_dim + 2*second_dim + length*width*height
    end
  end
end

puts "The elves should order '#{paper_surface}' square feet of wrapping paper"
puts "The elves should order '#{ribbon_length}' feet of ribbon"

exit 0
