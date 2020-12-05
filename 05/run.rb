#!/usr/bin/env ruby

def findit( str, bounds, low, high ) 
  str.each_char do |c|
    if c == low
        bounds = [ bounds[0], bounds[0] + ( bounds[1] - bounds[0] )/2 ]
    else
	bounds = [ bounds[0] + ( bounds[1] - bounds[0] )/2 + 1 , bounds[1] ]
    end
  end
  bounds[0]
end

seats = []
ARGF.each_line do |line|
  row = findit( line.chomp[0,7], [0,127], 'F', 'B' )
  column = findit( line.chomp[7,3], [0,7], 'L' ,'R'  )
  seats << row * 8 + column
end

# returns the [id,index] of the seat before ours. +1 to get ours
my_seat = seats.sort!.each_with_index.detect{ |id, index| seats[index+1] != id+1 }[0] + 1

puts "part 1 #{seats.max}"
puts "part 2 #{my_seat}"
