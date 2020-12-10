#!/usr/bin/env ruby

def count_paths( adapters, current, cache )
  paths = 1
  hits = ( current+1..current+3 ).select{ |index| index < adapters.length && ( adapters[index] - adapters[current] <= 3 ) }
  paths += ( hits.count - 1 ) if hits.count > 1
  hits.each do |h|
    child_paths = cache[h] || count_paths( adapters, h, cache )
    paths += ( child_paths - 1 ) if child_paths > 1
    cache[h] = child_paths
  end
  paths
end

adapters = ARGF.read.split(/\n/).map( &:to_i )
adapters = ( adapters | [0, adapters[adapters.count-1] + 3] ).sort

diffs = { 1 => 0, 3 => 0 }
adapters.each_cons(2) { |a| diffs[a.last-a.first] += 1 }

puts "part 1: #{diffs[1] * ( diffs[3])}"
puts "part 2: #{ count_paths( adapters, 0, {} ) }"



