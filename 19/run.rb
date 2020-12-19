#!/usr/bin/env ruby

def resolve( all_rules, target, part2 )
  result = "" 
  if part2 && target == 8
    result = resolve( all_rules, 42, part2 );
    result = "(?:#{result}+)";
  elsif part2 && target == 11
    r42 = resolve( all_rules, 42, part2 );
    r31 = resolve( all_rules, 31, part2 );
    
     # i feel like this resursive subexpr regex should work, but, it is high 
     # by 1. so - hacking it together manually to allow up to 4 matches gets us the answer
     # result = "(?<subexpr>#{r42}\\g<subexpr>*#{r31})"
     result = "(?:#{r42}#{r31}|#{r42}{2}#{r31}{2}|#{r42}{3}#{r31}{3}|#{r42}{4}#{r31}{4})"  
  elsif match = all_rules[target].match( /"(?<char>\w)"/ )
    result = match['char']
  else
    all_rules[target].split(/\s/).each do |token|
      if token == "|"
        result << token
      else
        # prob should cache these lookups
        result << resolve( all_rules, token.to_i, part2 )
      end
    end
    result = "(?:#{result})"
  end
  result
end

raw_rules = []
File.open( "rules.txt" ).each_line do |line|
  match = line.chomp.match( /\A(?<rule_num>\d+): (?<rules>.*)/ )
  raw_rules[match['rule_num'].to_i] = match['rules']
end

regex = "\\A#{resolve( raw_rules, 0, part2 = false )}\\z"
regex2 = "\\A#{resolve( raw_rules, 0, part2 = true )}\\z"

part1, part2 = 0,0
File.open( 'messages.txt' ).each_line do |line|
 line.chomp!
 part1 += 1 if line.match( regex )
 part2 += 1 if line.match( regex2 )
end

puts "part1: #{part1}"
puts "part2: #{part2}"




