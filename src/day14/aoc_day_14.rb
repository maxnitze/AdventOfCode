#!usr/bin/env ruby

# method for first part of day 14
def get_winning_reindeer reindeers, seconds
  reindeers.each { |r|
    full_time = r[:time]+r[:rest]
    r[:dist] = r[:speed]*(seconds/full_time*r[:time] + [seconds%full_time, r[:time]].min)
  }.sort_by { |r| r[:dist] }.last
end

def set_reindeer_fields! reindeers, seconds
  seconds.times.each do |i|
    reindeers.each { |r|
      r[:dist] += r[:speed] if (i%(r[:time] + r[:rest])).between? 1, r[:time]
    }

    reindeers.sort_by { |r| r[:dist] }.last[:points] += 1
  end
end

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

reindeers = []
seconds = 2503

File.open(input_file, 'r') do |f|
  f.readlines.map(&:chomp).each do |line|
    if match = line.match(/^(\S+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds\.$/)
      name, speed, time, rest = match.captures
      reindeers << { name: name, speed: speed.to_i, time: time.to_i, rest: rest.to_i, dist: 0, points: 0 }
    end
  end
end

set_reindeer_fields! reindeers, seconds

longest_distance_reindeer = reindeers.sort_by { |r| r[:dist] }.last
puts "The reindeer with the longest distance after '#{seconds}' seconds is \"#{longest_distance_reindeer[:name]}\" with a distance of #{longest_distance_reindeer[:dist]} km."

most_points_reindeer = reindeers.sort_by { |r| r[:points] }.last
puts "The reindeer with the most points after '#{seconds}' seconds is \"#{most_points_reindeer[:name]}\" with #{most_points_reindeer[:points]} points."

exit 0
