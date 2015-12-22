#!usr/bin/env ruby

def fight player, boss
  begin
    if (boss[:hp] -= player[:damage] - boss[:armor]) <= 0
      return player[:hp]
    end

    if (player[:hp] -= boss[:damage] - player[:armor]) <= 0
      return player[:hp]
    end
  end while player[:hp] > 0 && boss[:hp] > 0
  raise "can not happen since return statement is called in loop"
end

weapons = [
  { name: 'Dagger',     cost:  8, damage: 4, armor: 0 },
  { name: 'Shortsword', cost: 10, damage: 5, armor: 0 },
  { name: 'Warhammer',  cost: 25, damage: 6, armor: 0 },
  { name: 'Longsword',  cost: 40, damage: 7, armor: 0 },
  { name: 'Greataxe',   cost: 74, damage: 8, armor: 0 }
]

armors = [
  { name: 'Skin',       cost:   0, damage: 0, armor: 0 },
  { name: 'Leather',    cost:  13, damage: 0, armor: 1 },
  { name: 'Chainmail',  cost:  31, damage: 0, armor: 2 },
  { name: 'Splintmail', cost:  53, damage: 0, armor: 3 },
  { name: 'Bandedmail', cost:  75, damage: 0, armor: 4 },
  { name: 'Platemail',  cost: 102, damage: 0, armor: 5 }
]

rings = [
  { name: 'Blank',      cost:   0, damage: 0, armor: 0 },
  { name: 'Blank',      cost:   0, damage: 0, armor: 0 },
  { name: 'Damage +1',  cost:  25, damage: 1, armor: 0 },
  { name: 'Damage +2',  cost:  50, damage: 2, armor: 0 },
  { name: 'Damage +3',  cost: 100, damage: 3, armor: 0 },
  { name: 'Defense +1', cost:  20, damage: 0, armor: 1 },
  { name: 'Defense +2', cost:  40, damage: 0, armor: 2 },
  { name: 'Defense +3', cost:  60, damage: 0, armor: 3 }
]

boss = { hp: 100, damage: 8, armor: 2 }

min_cost_win = weapons.sort_by { |w| w[:cost] }.last[:cost] +
  armors.sort_by { |a| a[:cost] }.last[:cost] +
  rings.sort_by { |r| r[:cost] }.last(2).reduce(0) { |s, r| s + r[:cost] }
max_cost_lose = weapons.sort_by { |w| w[:cost] }.first[:cost] +
  armors.sort_by { |a| a[:cost] }.first[:cost] +
  rings.sort_by { |r| r[:cost] }.first(2).reduce(0) { |s, r| s + r[:cost] }

weapons.each do |weapon|
  armors.each do |armor|
    rings.combination(2).each do |ring_combs|
      cur_cost = weapon[:cost] + armor[:cost] + ring_combs.reduce(0) { |s, r| s + r[:cost] }

      min_cost_win = cur_cost if cur_cost < min_cost_win && fight(({
        hp: 100,
        damage: weapon[:damage] + armor[:damage] + ring_combs.reduce(0) { |s, r| s + r[:damage] },
        armor: weapon[:armor] + armor[:armor] + ring_combs.reduce(0) { |s, r| s + r[:armor] }
      }), boss.clone) > 0

      max_cost_lose = cur_cost if cur_cost > max_cost_lose && fight(({
        hp: 100,
        damage: weapon[:damage] + armor[:damage] + ring_combs.reduce(0) { |s, r| s + r[:damage] },
        armor: weapon[:armor] + armor[:armor] + ring_combs.reduce(0) { |s, r| s + r[:armor] }
      }), boss.clone) <= 0
    end
  end
end

puts "The least amount of gold to spend and still win the fight is '#{min_cost_win}'."
puts "The least amount of gold to spend and still lose the fight is '#{max_cost_lose}'."

exit 0
