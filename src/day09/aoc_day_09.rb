#!usr/bin/env ruby

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

distances = {}

File.open(input_file, 'r') do |f|
  f.readlines.map(&:chomp).each do |line|
    if match = line.match(/^(\S+) to (\S+) = (\d+)$/)
      city_1, city_2, dist = match.captures
      distances[city_1] = {} unless distances[city_1]
      distances[city_2] = {} unless distances[city_2]
      distances[city_1][city_2] = dist.to_i
      distances[city_2][city_1] = dist.to_i
    end
  end
end

# inspired by solution of gareve (https://www.reddit.com/r/adventofcode/comments/3w192e/day_9_solutions/cxtgagf)
longest_route, shortest_route = distances.keys.permutation.map { |perm|
  perm.each_cons(2).reduce(0) { |r, cities| r + distances[cities[0]][cities[1]] }
}.sort.rotate(-1).first(2)

puts "The distance of the shortest route is #{shortest_route}"
puts "The distance of the longest route is #{longest_route}"

exit 0
