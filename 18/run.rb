#!/usr/bin/env ruby

def eval_rpn( expression )
 stack = []
 expression.each do |e|
   if e == '+'
     stack << stack.pop + stack.pop
   elsif e == '*'
     stack << stack.pop * stack.pop
   else
    stack << e
   end
  end
  stack[0]
end

def generate_rpn( tokens, precedence )
 output, operator = [], []
 tokens.each do |token|
  if token == '+' || token == '*'
    while( ( operator.last == '+' || operator.last == '*' ) and
           ( precedence[operator.last] >= precedence[token] ) and
           ( operator.last != '(' ) ) 
      output << operator.pop
    end
    operator << token
  elsif token == ')'
    while( operator.last != '(' ) 
      output << operator.pop
    end
    if operator.last == '('
      operator.pop
    end
  elsif token == '('
    operator << token
  else
    output << token.to_i
  end
 end

 while( operator.count != 0 ) 
   output << operator.pop
 end
 
 output
end

part1, part2 = 0,0
ARGF.each_line do |line|
  tokens = line.chomp.scan( /[0-9\(\)+*]/ )  
  part1 += eval_rpn( generate_rpn( tokens, { '+' => 1, '*' => 1 } ) )
  part2 += eval_rpn( generate_rpn( tokens, { '+' => 2, '*' => 1 } ) )
end

puts "part 1: #{part1}"
puts "part 2: #{part2}"



