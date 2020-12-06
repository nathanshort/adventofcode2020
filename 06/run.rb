#!/usr/bin/env ruby

union_sum, intersection_sum = 0,0

File.read( ARGV[0] ).split( /^\n/ ).each do |groups|
  union, intersection = [], []
  groups.split( /\s/ ).each_with_index do |person,index|
    yesses = person.chars
    intersection = index == 0 ? yesses : intersection & yesses
    union |= yesses
  end
  union_sum += union.count
  intersection_sum += intersection.count
end

puts "part 1: #{union_sum}"
puts "part 2: #{intersection_sum}"