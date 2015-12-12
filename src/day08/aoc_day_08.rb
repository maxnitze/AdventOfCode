#!usr/bin/env ruby

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

code_chars = 0
real_chars = 0
esc_chars = 0

File.open(input_file, 'r') do |f|
  f.readlines.map(&:chomp).each do |line|
    code_chars += line.length
    real_chars += eval(line).length
    esc_chars += line.dump.length
  end
end

puts "The calculated total number of characters in the file is #{code_chars - real_chars}."
puts "The calculated total number of characters in the file is #{esc_chars - code_chars}."

exit 0
