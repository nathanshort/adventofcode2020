#!/usr/bin/env ruby

require 'scanf'

sled_valid = 0
toboggan_valid = 0 

ARGF.each_line do |line|
   low, high, letter, password = line.chomp.scanf("%d-%d %c: %s")
   count = password.count( letter )
   sled_valid += 1 if count >= low and count <= high
   toboggan_valid +=1 if ( ( password[low-1] == letter ? 1 : 0 ) + ( password[high-1] == letter ? 1 : 0 ) ) == 1
end

puts "part 1: #{sled_valid}"
puts "part 2: #{toboggan_valid}"
