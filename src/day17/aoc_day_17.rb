#!usr/bin/env ruby

def get_fitting_combinations left_liters, cs, i
  if i < @containers.size && left_liters > 0
    return get_fitting_combinations(left_liters-@containers[i], cs + [@containers[i]], i+1) + get_fitting_combinations(left_liters, cs, i+1)
  elsif left_liters == 0
    return [cs]
  else
    return []
  end
end

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

liters = 150
@containers = []

File.open(input_file, 'r') do |f|
  f.readlines.map(&:chomp).each do |line|
    if match = line.match(/^(\d+)$/)
      @containers << match[1].to_i
    end
  end
end

combs = get_fitting_combinations(liters, [], 0)
puts "'#{combs.size}' combinations of the containers can exactly fit all '#{liters}' liters of eggnog."

min_combs = combs.select { |c| c.size == combs.min_by { |c| c.size }.size }
puts "'#{min_combs.size}' fitting combinations have the minimum of '#{min_combs.first.size}' containers."

exit 0
