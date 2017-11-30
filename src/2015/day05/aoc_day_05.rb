#!usr/bin/env ruby

def is_nice_1 line
  line.match(/[aeiou].*[aeiou].*[aeiou]/) && line.match(/(.)\1/) && !line.match(/(ab|cd|pq|xy)/)
end

def is_nice_2 line
  line.match(/(\S{2}).*\1/) && line.match(/(\S)\S\1/)
end

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

nice_strings_1 = 0
nice_strings_2 = 0

File.open(input_file, 'r') do |f|
  f.each_line do |line|
    nice_strings_1 += 1 if is_nice_1 line
    nice_strings_2 += 1 if is_nice_2 line
  end
end

puts "There are '#{nice_strings_1}' nice strings for part 1."
puts "There are '#{nice_strings_2}' nice strings for part 2."

exit 0
