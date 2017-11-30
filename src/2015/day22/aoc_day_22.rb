#!usr/bin/env ruby

@min_boss_hp = 58
@mana_boss_hp = 1000000
@print_mutex = Mutex.new

@magics = {
  missile:  { name: 'Missile',  mana:  53, type: :instant, change: { damage: 4 } },
  drain:    { name: 'Drain',    mana:  73, type: :instant, change: { damage: 2, health: 2 } },
  shield:   { name: 'Shield',   mana: 113, type: :expire,  change: { turns:  6, armor: 7 } },
  poison:   { name: 'Poison',   mana: 173, type: :repeat,  change: { turns:  6, damage: 3 } },
  recharge: { name: 'Recharge', mana: 229, type: :repeat,  change: { turns:  5, mana: 101 } }
}

@cur_thread_counter = 0
@next_thread_counter = 0
@sleeping_threads = []
@counter_mutex = Mutex.new

def decrease_cur_counter
  @counter_mutex.synchronize do
    if @cur_thread_counter > 0
      @cur_thread_counter -= 1
      if @cur_thread_counter == 0
        @cur_thread_counter = @next_thread_counter
        @next_thread_counter = 0

        @sleeping_threads.each &:wakeup
        @sleeping_threads.clear
      end
    else
      raise "can not decrease current thread counter'!\n"
    end
  end
end

def increase_next_counter value
  @counter_mutex.synchronize do
    @next_thread_counter += value
  end
end

def has_lower_turn_threads
  @counter_mutex.synchronize do
    return @cur_thread_counter > 0
  end
end

@min_mana = -1
@min_mana_mutex = Mutex.new

def get_minimum_mana player, boss, turn, mana_used, runnings
  @min_mana_mutex.synchronize do
    if boss[:hp] <= 0
      @min_mana = mana_used if mana_used > -1 && (@min_mana < 0 || mana_used < @min_mana)
      puts "killed boss in turn '#{turn}' with '#{mana_used}' mana used\n"
      return
    elsif player[:hp] <= 0
      puts "died in turn '#{turn}' with '#{mana_used}' mana used\n"
      return
    elsif @min_mana > -1 && mana_used >= @min_mana
      puts "canceled combat turn '#{turn}' with '#{mana_used}' mana used\n"
      return
    end
  end

  while has_lower_turn_threads do
    if @min_mana > -1 && mana_used >= @min_mana
      puts "canceled combat turn '#{turn}' with '#{mana_used}' mana used\n"
      return
    end

    @sleeping_threads << Thread.current
    sleep
  end

  @print_mutex.synchronize do
    if boss[:hp] < @min_boss_hp || (boss[:hp] == @min_boss_hp && mana_used < @mana_boss_hp)
      @min_boss_hp = boss[:hp]
      @mana_boss_hp = mana_used
      puts "reached new minimum boss hp '#{boss[:hp]}' with '#{@mana_boss_hp}' mana used in turn '#{turn}'\n"
    end
  end

  runnings.each_with_index do |magics_row, i|
    if magics_row
      magics_row.each do |named_magic|
        named_magic.each do |magic_name, magic|
          if magic[:type].eql? :repeat
            player[:hp] += magic[:health] if magic[:health]
            player[:mana] += magic[:mana] if magic[:mana]
            player[:armor] += magic[:armor] if magic[:armor]

            boss[:hp] -= magic[:damage] if magic[:damage]
          elsif magic[:type].eql? :expire
            player[:armor] -= magic[:armor] if i == 0 && magic[:armor]
          end
        end
      end
    end
  end
  runnings.shift

  if turn%2 == 0
    can_afford = 0
    threads = []
    @magics.each do |magic_name, magic|
      if player[:mana] >= magic[:mana]
        can_afford += 1

        if !runnings.any? { |r| r && r.any? { |m| m.any? { |name, _| name.eql? magic_name } } }
          threads << Thread.new {
            sleep

            t_player = player.clone
            t_boss = boss.clone
            t_runnings = runnings.clone

            if [:instant, :expire].include? magic[:type]
              t_player[:hp] += magic[:change][:health] if magic[:change][:health]
              t_player[:mana] += magic[:change][:mana] if magic[:change][:mana]
              t_player[:armor] += magic[:change][:armor] if magic[:change][:armor]

              t_boss[:hp] -= magic[:change][:damage] if magic[:change][:damage]
            end

            if [:expire, :repeat].include? magic[:type]
              (t_runnings[magic[:change][:turns]] ||= []) << {
                magic_name => {
                  type: magic[:type],
                  health: magic[:change][:health],
                  mana: magic[:change][:mana],
                  damage: magic[:change][:damage],
                  armor: magic[:change][:armor]
                }
              }
            end

            t_player[:mana] -= magic[:mana]

            get_minimum_mana(t_player, t_boss, (turn+1), (mana_used+magic[:mana]), t_runnings)
          }
        end
      end
    end

    if can_afford == 0
      puts "can not afford any magic in turn '#{turn}' with '#{mana_used}' mana used\n"
      decrease_cur_counter if turn > 0
      return
    elsif threads.empty? # can afford another magic that is already 'running'
      get_minimum_mana(player, boss, (turn+1), mana_used, runnings)
      decrease_cur_counter if turn > 0
    else
      increase_next_counter threads.size
      decrease_cur_counter if turn > 0
      threads.each &:wakeup
      threads.each &:join
    end
  else
    boss_damage = boss[:damage] - player[:armor]
    player[:hp] -= boss_damage > 0 ? boss_damage : 1

    get_minimum_mana(player, boss, (turn+1), mana_used, runnings)
    decrease_cur_counter if turn > 0
  end
end

player = { hp: 500, armor:  0, mana: 500 }
boss =   { hp:  58, damage: 9 }

get_minimum_mana player, boss, 0, 0, []

puts "The least amount of mana you can spend to win the fight is '#{@min_mana}'."

exit 0
