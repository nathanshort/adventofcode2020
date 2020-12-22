#!/usr/bin/env ruby

p1,p2 = ARGF.read.split(/\n\n/).map{|p| p.split(/\n/).select{|c| !c.match(/Player/) }.map(&:to_i ) }
p12, p22 = p1.dup, p2.dup

def score( deck )
  sum, len = 0, deck.count
  deck.each_with_index{|c,index| sum += c*( len-index )}
  sum
end

def recursive( p1, p2 )
  seen = {}
  while ! p1.empty? && ! p2.empty? 
    sig = "#{score(p1)},#{score(p2)}"
    return :one if seen.key?( sig )
    seen[sig] = true

    c1, c2 = p1.shift, p2.shift
    if ( p1.count >= c1 ) && ( p2.count >= c2 )
      winner = recursive( p1.slice(0,c1), p2.slice(0,c2) )
    else 
      winner = c1 > c2 ? :one : :two 
    end
    p1 << c1 << c2 if winner == :one
    p2 << c2 << c1 if winner == :two
  end
  return p1.empty? ? :two : :one
end

# part 1
while ! p1.empty? && ! p2.empty?
  c1, c2 = p1.shift, p2.shift
  if c1 > c2
    p1 << c1 << c2
  else
    p2 << c2 << c1
  end
end
puts "part1: #{score( p1 ) + score( p2 )}"

recursive( p12, p22 )
puts "part2: #{score( p12 ) + score( p22 )}"

