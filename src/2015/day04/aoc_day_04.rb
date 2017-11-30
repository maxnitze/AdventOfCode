#!usr/bin/env ruby

require 'digest/md5'


key = 'iwrupvqb'

i = 0
begin
  digest = Digest::MD5.hexdigest("#{key}#{i}")
  i += 1
end while !digest[0..4].eql?('00000')
five_zero_md5 = i-1

i = 0
begin
  digest = Digest::MD5.hexdigest("#{key}#{i}")
  i += 1
end while !digest[0..5].eql?('000000')
six_zero_md5 = i-1

puts "The lowest positive number to produce a md5 hash starting with '00000' if preceeded by '#{key}' is #{five_zero_md5}"
puts "The lowest positive number to produce a md5 hash starting with '000000' if preceeded by '#{key}' is #{six_zero_md5}"

exit 0
