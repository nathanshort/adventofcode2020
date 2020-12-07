#!/usr/bin/env ruby

def part1( all_rules, target, seen ) 
  count = 0
   all_rules.each do |color,children|
      if children.any?{|child| ! seen.key?(color) && child[:color] == target }
         seen[color] = true
         count = count + 1 + part1( all_rules, color, seen )
      end
   end
  count
end

def part2( all_rules, target )
  count = 0
  all_rules[target].each do |child|
    count = count + child[:count] + child[:count] * part2( all_rules, child[:color] )
 end
 count
end 


rules = {}
ARGF.each_line do |line|
  matches = line.chomp.match(/\A(?<parent>.*) bags contain (?<all_children>.*)\.\z/ ) 
   all_children = []
   matches['all_children'].split(", ").each do |child|
    child_match = child.match( /\A(?<num>\d+) (?<color>.*) bag/ )
    all_children << { :color => child_match['color'], :count => child_match['num'].to_i } if ! child_match.nil?
   end
  rules[matches['parent']] = all_children
end

puts "part 1: #{ part1( rules, 'shiny gold', {} )}"
puts "part 2: #{ part2( rules, 'shiny gold' ) }"




