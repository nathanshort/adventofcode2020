#!/usr/bin/env ruby

preamble_length = 25
preamble = []
sums = {}
all_data = []

ARGF.each_line.with_index do |line,index|
   item = line.chomp.to_i
   all_data << item
   if index < preamble_length 
     preamble.map { |p| sums[ item + p ] = ( sums[ item + p ] || 0 ) + 1 }
     preamble << item
   end
end   


target = all_data[preamble_length..].each.detect do |item|
  if ! sums.key?(item)
    item     
  else
   to_remove = preamble.shift     
   preamble.map do |i|
    sum_to_remove = i + to_remove
    sums[ i+item ] = ( sums[ i + item ] || 0 ) + 1
    sums[ sum_to_remove ] -= 1
    sums.delete( sum_to_remove  ) if ( sums[ sum_to_remove ] == 0 )
   end
   preamble << item    
   nil  
  end
end         

puts "part 1: #{target}"

(0..(all_data.length - 1) ).each do |index|
  sum = all_data[index]
  ( index+1..all_data.length - 1 ).each do |other_index|
     sum += all_data[other_index]
     if sum == target
       puts "part 2: #{all_data.slice(index..other_index).minmax.sum}"
       exit
     end 
  end   
end



