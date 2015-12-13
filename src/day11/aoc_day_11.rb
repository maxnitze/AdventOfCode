#!usr/bin/env ruby

@inc_straight_letters = ('a'..'z').to_a.each_cons(3).map &:join

def match_requirements password
  password.match("(#{@inc_straight_letters.join '|'})") && !password.match(/[iol]/) && password.match(/((\S)\2).*(((?!\2)\S)\4)/)
end

def get_new_password password
  begin
    password.succ!
    raise "there is no next password from \"#{password}\" that matches the requirements" if password.length > 8
  end while !match_requirements password
  password
end

old_password = "cqjxjnds"

new_password_1 = get_new_password old_password
puts "Starting with password \"#{old_password}\" the next matching password is \"#{new_password_1}\""
new_password_2 = get_new_password new_password_1
puts "And starting with this new password the next matching password is \"#{new_password_2}\""

exit 0
