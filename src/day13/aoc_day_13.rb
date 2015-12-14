#!usr/bin/env ruby

def get_max_happiness happiness
  happiness.keys.flatten.uniq.permutation.map { |perm|
    perm.each_cons(2).reduce(0) { |r, persons| r + happiness[persons.sort] } + happiness[[perm[-1], perm[0]].sort]
  }.sort.last
end

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

happiness = Hash.new 0

File.open(input_file, 'r') do |f|
  f.readlines.map(&:chomp).each do |line|
    if match = line.match(/^(\S+) would (gain|lose) (\d+) happiness units by sitting next to (\S+)\.$/)
      person_1, g_or_l, amount, person_2 = match.captures
      happiness[[person_1, person_2].sort] += g_or_l.eql?('gain') ? amount.to_i : -amount.to_i
    end
  end
end

max_happiness = get_max_happiness happiness
puts "The total change in happiness for the optimal seating arrangement of the actual guest list is #{max_happiness}."

max_happiness = get_max_happiness happiness.merge(happiness.keys.flatten.uniq.each_with_object({}) { |p, h| h[[p, 'ME'].sort] = 0 })
puts "Including myself the total change in happiness for the optimal seating arrangement changes to #{max_happiness}."

exit 0
