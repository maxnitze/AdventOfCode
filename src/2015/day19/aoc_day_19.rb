#!usr/bin/env ruby

def get_minimum_steps molecule, depth
    (@replacements.each_with_object([]) { |repl, array|
      occ = 0
      molecule.scan(/#{repl.last}/).count.times do
        array << get_minimum_steps((molecule.gsub(/#{repl.last}/).with_index { |_, i|
          occ == i ? repl.first : repl.last
        }), (depth+1))
        occ += 1
      end
    }.compact.min)
end

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

@replacements = []
molecule = nil

File.open(input_file, 'r') do |f|
  f.readlines.map(&:chomp).each do |line|
    if match = line.match(/^(?<molecule>\S+) => (?<replacement>\S+)$/)
      @replacements << [match['molecule'], match['replacement']]
    elsif match = line.match(/^(?<molecule>\S+)$/)
      molecule = match['molecule']
    end
  end
end

molecules = @replacements.each_with_object([]) do |repl, array|
  occ = 0
  molecule.scan(/#{repl.first}/).count.times do
    array << molecule.gsub(/#{repl.first}/).with_index { |_, i|
      occ == i ? repl.last : repl.first
    }
    occ += 1
  end
end

puts "'#{molecules.uniq.size}' distinct modules can be created."

steps = get_minimum_steps molecule, 0

puts "It takes at least '#{steps}' steps to get the medicine starting by 'e'."

exit 0
