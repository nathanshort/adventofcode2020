#!/usr/bin/env ruby

map = {}
height, width = 0,0

ARGF.each_line do |line|
  line.chomp!.each_char.with_index {|c,x| map["#{x},#{height}"] = c; width = x }
  height+=1
 end

product = 1
[[1,1],[3,1],[5,1],[7,1],[1,2]].each do |slope|
  position = [0,0]
  hits = 0
  while position[1] <= height do
    position = [ ( position[0]+slope[0] ) % ( width + 1 ), position[1]+slope[1] ]
    hits+=1 if map["#{position[0]},#{position[1]}"] == '#'
  end
  product *= hits
  puts "part 1: #{hits}" if [3,1] == slope
end

puts "part 2: #{product}"
