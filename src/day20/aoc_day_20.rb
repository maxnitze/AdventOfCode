#!usr/bin/env ruby

def get_gifts_for_house house
  10 * (1..Math.sqrt(house).floor).reduce(0) { |s, i|
    s + (house%i == 0 ? (i == house/i ? i : i+house/i) : 0)
  }
end

gift_threshold = 33100000

house = 0
begin
  house += 1
  raise "There is no house with more than '#{gift_threshold}' gifts." unless house < gift_threshold/10
end while get_gifts_for_house(house) < gift_threshold

puts "The first house that gets more than '#{gift_threshold}' gifts is house '#{house}'."

exit 0
