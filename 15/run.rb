#!/usr/bin/env ruby

def run( input, iterations )
 spoken_history = {}
 input.each.with_index do |item,index |
  spoken_history[item] = [index+1]
 end

 most_recent = input.last
 turn = input.length + 1

 while turn <= iterations do
   if spoken_history[most_recent].length == 1
     most_recent = 0
   else
     most_recent = spoken_history[most_recent].last - spoken_history[most_recent].first
   end
   if spoken_history.key?(most_recent )
     spoken_history[most_recent] = [ spoken_history[most_recent].last, turn ]
   else
     spoken_history[most_recent] = [turn]
   end
  turn += 1
 end
 most_recent
end

input = '0,14,6,20,1,4'.split(",").map( &:to_i )

p run( input, 2020 )
p run( input, 30_000_000 )


