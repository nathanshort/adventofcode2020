#!/usr/bin/env ruby

require_relative '../lib/common'

all_moves = []
ARGF.each_line do |line| 
  line.chomp!  
  all_moves << { :direction => line[0], :by => line[1..].to_i }
end

ship = Cursor.new( :heading => 'E' )
all_moves.each do |move|
  case move[:direction]
    when 'N','E','S','W'
      ship.move( move )
    when 'L', 'R'
      ( move[:by] / 90 ).times { ship.turn( :direction => move[:direction]) }
    when 'F'
      ship.forward( :by => move[:by] )
    end
end
puts "part 1: #{ship.location.x.abs + ship.location.y.abs}"


# not really a Cursor, but, we'll use it for its move().  the heading is not used
waypoint = Cursor.new( :x => 10, :y => 1 )
ship = Point.new( 0, 0 )

all_moves.each do |move|
   case move[:direction]
    when 'N','E','S','W'
      waypoint.move( move )
    when 'L', 'R'
      ( move[:by] / 90 ).times { waypoint.rotate( :direction => move[:direction]) }
    when 'F'
      ship.x += waypoint.location.x * move[:by]
      ship.y += waypoint.location.y * move[:by]
    end
end
puts "part 2: #{ship.x.abs + ship.y.abs}"


