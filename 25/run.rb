#!/usr/bin/env ruby

def determine_loop_size( target )
    counter, subject, value = 0, 7, 1
    while
      value *= subject
      value %= 20201227
      counter += 1
      return counter if value == target
    end
end

def transform( subject, loop_size )
    value = 1
    loop_size.times do 
       value *= subject
        value %= 20201227
    end
    value
end

card_pub, door_pub = 14205034, 18047856
door_loop = determine_loop_size( door_pub )
card_loop = determine_loop_size( card_pub )

puts transform( card_pub, door_loop )
