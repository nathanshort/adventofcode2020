#!/usr/bin/env ruby

require_relative '../lib/common'

actives3, actives4 = {},{}

z,w = 0,0
ARGF.each_line.with_index do |line,y|
  line.chomp.chars.each_with_index do |c,x|
     actives3[ PointNd.new([ x,y,z ]) ] = true if c == '#' 
     actives4[ PointNd.new( [x,y,z,w] ) ] = true if c == '#'
  end
end

6.times do |cycle|
 result = {}
 checked = {}
 to_scan = actives3.keys | actives3.keys.map{ |a| a.adjacent }.flatten

 to_scan.each do |point|
   next if checked.key?( point )
   checked[point] = true
   active_adjacent_count = 0  
   point.adjacent.each do |adj|
     active_adjacent_count += 1 if actives3.key?(adj)
   end
  if ( actives3.key?(point) && (2..3).cover?(active_adjacent_count ) ) || ( ! actives3.key?(point) && active_adjacent_count == 3 )
    result[point] = true
  end   
 end
 actives3 = result
end

puts "part 1:#{actives3.keys.count}"


6.times do |cycle|
   result = {}
   checked = {}
   to_scan = actives4.keys | actives4.keys.map{ |a| a.adjacent }.flatten
 
   to_scan.each do |point|
     next if checked.key?( point )
     checked[point] = true
     active_adjacent_count = 0
     point.adjacent.each do |adj|
       active_adjacent_count += 1 if actives4.key?(adj)
     end
    if ( actives4.key?(point) && (2..3).cover?(active_adjacent_count ) ) || ( ! actives4.key?(point) && active_adjacent_count == 3 )
      result[point] = true
    end
   end
   actives4 = result
  end

puts "part 2:#{actives4.keys.count}"

