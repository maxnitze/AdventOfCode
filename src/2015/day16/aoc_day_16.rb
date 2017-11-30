#!usr/bin/env ruby

def matches aunt
  aunt[:compounds].all? { |c| @ticker_tape_output[c[0].to_sym] == c[1].to_i }
end

def matches_updated_cabulator aunt
  aunt[:compounds].all? do |c|
    ['cats', 'trees'].include?(c[0]) ? @ticker_tape_output[c[0].to_sym] < c[1].to_i :
      (['pomeranians', 'goldfish'].include?(c[0]) ? @ticker_tape_output[c[0].to_sym] > c[1].to_i :
        @ticker_tape_output[c[0].to_sym] == c[1].to_i)
  end
end

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

@ticker_tape_output = {
  children: 3,
  cats: 7,
  samoyeds: 2,
  pomeranians: 3,
  akitas: 0,
  vizslas: 0,
  goldfish: 5,
  trees: 3,
  cars: 2,
  perfumes: 1
}

aunts = []

File.open(input_file, 'r') do |f|
  f.readlines.map(&:chomp).each do |line|
    if match = line.match(/^Sue (\d+): ((, )?(children|cats|samoyeds|pomeranians|akitas|vizslas|goldfish|trees|cars|perfumes): (\d+))*$/)
      aunts << { number: match[1].to_i, compounds: line.scan(/(children|cats|samoyeds|pomeranians|akitas|vizslas|goldfish|trees|cars|perfumes): (\d+)/) }
    end
  end
end

puts "The number of the Sue, whom got me the gift is '#{aunts.select { |s| matches s }.first[:number]}'"
puts "After fixing the retroencabulator, the number is '#{aunts.select { |s| matches_updated_cabulator s }.first[:number]}'"

exit 0
