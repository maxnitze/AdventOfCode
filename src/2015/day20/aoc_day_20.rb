#!usr/bin/env ruby

def get_lower_boundary threshold, count
  sum = 0; step = 0
  begin
    sum += step += 1
  end while sum < threshold/count
  step
end

def get_gifts_for_house house, gift_c, max = -1
  gift_c * (1..Math.sqrt(house).floor).reduce(0) { |s, i|
    s + (house%i == 0 ?
        ((max == -1 || i*max >= house ? i : 0)
      + (i != house/i && (max == -1 || max/i >= 1) ? house/i : 0)) : 0)
  }
end

gift_threshold = 33100000

gift_c_1 = 10
house = get_lower_boundary gift_threshold, gift_c_1
begin
  house += 1
  raise "There is no house with more than '#{gift_threshold}' gifts." unless house < gift_threshold/gift_c_1
end while get_gifts_for_house(house, gift_c_1) < gift_threshold

puts "The first house that gets more than '#{gift_threshold}' gifts is house '#{house}'."

gift_c_2 = 11
max_deliveries = 50
house = get_lower_boundary gift_threshold, gift_c_2
begin
  house += 1
  raise "There is no house with more than '#{gift_threshold}' gifts." unless house < gift_threshold/gift_c_2
end while get_gifts_for_house(house, gift_c_2, max_deliveries) < gift_threshold

puts "With max '#{max_deliveries}' deliveries per elf, the first house that gets more than '#{gift_threshold}' gifts is house '#{house}'."

exit 0
