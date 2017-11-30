#!usr/bin/env ruby

def get_cached_value var
  @cached_values[var] || @original_exprs[var]
end

def get_value var
  if match = var.to_s.match(/^(\d+)$/)
    value = match[1].to_i
  elsif match = var.to_s.match(/^(\S+)$/)
    value = parse_expr get_cached_value match[1]
    @cached_values[var] = value
  else
    raise "can not get value for variable '#{var}'"
  end

  value
end

def parse_expr expr
  if match = expr.to_s.match(/^(\S+|\d+)$/)
    value = get_value match[1]
  elsif match = expr.to_s.match(/^(\S+|\d+) AND (\S+|\d+)$/)
    value = get_value(match[1]) & get_value(match[2])
  elsif match = expr.to_s.match(/^(\S+|\d+) OR (\S+|\d+)$/)
    value = get_value(match[1]) | get_value(match[2])
  elsif match = expr.to_s.match(/^NOT (\S+|\d+)$/)
    value = ~get_value(match[1])
  elsif match = expr.to_s.match(/^(\S+) LSHIFT (\d+)$/)
    value = (get_value(match[1]) << match[2].to_i) & ((1<<16)-1)
  elsif match = expr.to_s.match(/^(\S+) RSHIFT (\d+)$/)
    value = get_value(match[1]) >> match[2].to_i
  else
    raise "can not parse expression '#{expr}'"
  end

  value
end

if ARGV[0] && File.file?(ARGV[0])
  input_file = ARGV[0]
else
  puts 'either no argument given or argument is not a file'
  exit 1
end

@original_exprs = {}
@cached_values = {}

File.open(input_file, 'r') do |f|
  f.each_line do |line|
    if match = line.match(/^(.*) -> (\S+)$/)
      value, var = match.captures
      @original_exprs[var] = value
    end
  end
end

wire_a1 = parse_expr 'a'
@original_exprs['b'] = wire_a1
@cached_values = {}
wire_a2 = parse_expr 'a'

puts "The signal '#{wire_a1}' is ultimately provided to wire 'a'."
puts "After overriding wire 'b' with this value, '#{wire_a2}' is ultimately provided to wire 'a'."

exit 0
