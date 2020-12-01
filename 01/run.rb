#!/usr/bin/env ruby

def findit( values, take, target )
  sums = values.combination(take) do |e|
    sum = e.inject(0,:+)
    if sum == target
     return e.inject(1,:*)
    end
  end
end

values = []
File.open( "input.txt" ) do |f|
  f.each_line do |line|
   values <<line.chomp.to_i  
  end
end

puts "1: #{findit( values, 2, 2020 )}"
puts "2: #{findit( values, 3, 2020 )}"
