#!/usr/bin/env ruby

require_relative '../lib/common'

EMPTY = 'L'
OCCUPIED = '#'
FLOOR = '.'

original = Grid.new( :io => ARGF )
current = original.dup

# part 1 
loop do 
 previous = current.dup
 previous.each do |point,value|
    current[point] = case value
    when EMPTY
      point.adjacent.all? {|a| ! previous.points.key?(a) || ( previous[a] != OCCUPIED ) } ? OCCUPIED : nil
    when OCCUPIED
      point.adjacent.count {|a| previous[a] == OCCUPIED } >= 4 ? EMPTY : nil
    end || previous[point]
 end
 break if previous == current
end
puts "part 1: #{current.points.count{|k,v| v == OCCUPIED }}"

# part 2 
directions = [[-1,0],[-1,-1],[0,-1],[1,-1],[1,0],[1,1],[0,1],[-1,1]]
current = original.dup

loop do 
  previous = current.dup
  previous.each do |point,value|
    first_visibles = []
    directions.each do |d|
      pp = Point.new( point.x,point.y)
        loop do
          pp.x += d[0]
          pp.y += d[1]
          if ! previous.points.key?(pp)
            break
          elsif previous[pp] != FLOOR
            first_visibles << previous[pp]
            break
          end
        end 
    end

    current[point] = case value
      when EMPTY
       first_visibles.all? {|f| f != OCCUPIED } ? OCCUPIED : nil
      when OCCUPIED
       first_visibles.count {|f| f == OCCUPIED } >= 5 ? EMPTY : nil
     end || previous[point]
  end
  break if previous == current
end

puts "part 2: #{current.points.count{|k,v| v == OCCUPIED }}"


