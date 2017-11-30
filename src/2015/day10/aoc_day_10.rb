#!usr/bin/env ruby

def look_and_say_seq string, iterations
  iterations.times do
    string = string.scan(/((\d)\2*)/).map(&:first).each_with_object "" do |sc, str|
      str << "#{sc.length}#{sc[0]}"
    end
  end
  string
end

input = "1113222113"

puts "The length of the look-and-say sequence for input \"#{input}\" after 40 iterations is \"#{look_and_say_seq(input, 40).length}\""
puts "The length of the look-and-say sequence for input \"#{input}\" after 50 iterations is \"#{look_and_say_seq(input, 50).length}\""

exit 0
