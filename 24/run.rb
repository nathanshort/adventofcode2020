#!/usr/bin/env ruby

flipped_to_black = {}
ARGF.each_line do |line|
    x,y,z = 0,0,0
    line.chomp.scan( /e|se|sw|w|nw|ne/ ).each do |direction|
      # https://www.redblobgames.com/grids/hexagons/#neighbors
      case direction
       when 'e'
        x+=1; y-=1
       when 'se'
        z+=1; y-=1;
       when 'sw'
        x-=1; z+=1
       when 'w'
        x-=1; y+=1;
       when 'nw'
        y+=1; z-=1;
       when 'ne'
        x+=1; z-=1;
       end
     end
     p = [x,y,z]
     if flipped_to_black.key?( p )
      flipped_to_black.delete( p )
     else
      flipped_to_black[p] = 1
    end
  end
puts "part1: #{flipped_to_black.keys.count}"

def neighbors( point )
  [ [1,-1,0], [1,0,-1], [0,1,-1], [-1,1,0], [-1,0,1], [0,-1,1] ].map do |offset|
     [point[0]+offset[0], point[1]+offset[1], point[2]+offset[2] ]
  end
end

100.times do
    to_white, to_black = [], []
    
    # should cache these counts.  we're doing multiple of the 
    # same neighbor counts per round here
    flipped_to_black.each do |hex,_|
      my_neighbor_count = 0
      neighbors( hex ).each do |n|
        if flipped_to_black.key?(n)
          my_neighbor_count += 1
        else
          my_neighbors_neighbor_count = 0 
          neighbors(n).each do |nn|
            my_neighbors_neighbor_count += 1 if flipped_to_black.key?( nn )
          end
          to_black << n if my_neighbors_neighbor_count == 2
        end
      end
      to_white << hex if my_neighbor_count == 0 || my_neighbor_count > 2 
    end
    to_white.each {|p| flipped_to_black.delete(p) }
    to_black.each {|p| flipped_to_black[p] = true }
end

puts "part2: #{flipped_to_black.keys.count}"
