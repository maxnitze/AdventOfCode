#!usr/bin/env ruby

def increment_array! array, total
  inced = increment_array_with_idx! array, 0, total
  array[0] = total-array[1..-1].reduce(0) { |s, e| s + e }
  inced
end

def increment_array_with_idx! array, i, total
  return false if i>=array.size-1

  array[i] = 0
  if array[i+1..-1].reduce(0) { |s, e| s + e }+1 <= total
    array[i+1] += 1
    return true
  else
    return increment_array_with_idx! array, i+1, total
  end
end

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

total_teaspoons = 100
ingredients = []

File.open(input_file, 'r') do |f|
  f.readlines.map(&:chomp).each do |line|
    if match = line.match(/^(\S+): capacity ([+-]?\d+), durability ([+-]?\d+), flavor ([+-]?\d+), texture ([+-]?\d+), calories ([+-]?\d+)$/)
      ingredients << Hash[[:name, :capacity, :durability, :flavor, :texture, :calories]
        .zip([match.captures[0]] + match.captures[1..6].map { |c| c.to_i })]
    end
  end
end

cur_distr = Array.new ingredients.length, 0
cur_distr[0] = total_teaspoons

scorings = []
begin
  capacity = 0; durability = 0; flavor = 0; texture = 0; calories = 0

  cur_distr.each_with_index do |amount, i|
    capacity += ingredients[i][:capacity]*amount
    durability += ingredients[i][:durability]*amount
    flavor += ingredients[i][:flavor]*amount
    texture += ingredients[i][:texture]*amount
    calories += ingredients[i][:calories]*amount
  end

  scorings << { distr: cur_distr, score: [capacity,0].max*[durability,0].max*[flavor,0].max*[texture,0].max, calories: calories }
end while increment_array! cur_distr, total_teaspoons

puts "The total score of the highest-scoring cookie is '#{scorings.sort_by { |s| s[:score] }.last[:score]}'."
puts "The total score of the highest-scoring cookie with exactly '500' calories is '#{scorings.select { |s| s[:calories] == 500 }.sort_by { |s| s[:score] }.last[:score]}'."

exit 0
