#!/usr/bin/env ruby

def find_it( str, bounds, low, high ) 
  str.each_char do |c|
    middle = bounds[0] + ( bounds[1] - bounds[0] ) / 2
    if c == low
        bounds = [ bounds[0], middle ]
    else
	bounds = [ middle + 1 , bounds[1] ]
    end
  end
  bounds[0]
end

seats = []
ARGF.each_line do |line|
  pass = line.chomp
  row = find_it( pass[0..6], [0,127], 'F', 'B' )
  column = find_it( pass[7..9], [0,7], 'L' ,'R'  )
  seats << row * 8 + column
end

# returns the [id,index] of the seat before ours. +1 to get ours
my_seat = seats.sort!.each_with_index.detect{ |id, index| seats[index+1] != id+1 }[0] + 1

puts "part 1 #{seats.max}"
puts "part 2 #{my_seat}"
