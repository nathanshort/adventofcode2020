#!/usr/bin/env ruby

target_timestamp = ARGF.gets.chomp.to_i
all_busses = ARGF.gets.chomp.split(/,/)

part1_busses = all_busses.select{|x| x != "x" }.map( &:to_i )
part1 = part1_busses.min_by {|x| target_timestamp + x - ( target_timestamp % x ) }
puts "part1: #{part1 * (  part1 - ( target_timestamp % part1 ))}" 

all_busses.each.with_index do |item,index|
  next if item == "x"
  print "(x+#{index})%#{item} = 0,"
end

# now plug ^ into a solver
