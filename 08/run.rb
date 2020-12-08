#!/usr/bin/env ruby

require 'scanf'

def run( instructions )

  pc, accum = 0, 0
  seen = {}

  while true do

   return { :accum => accum, :status => :infinite } if seen[pc]
   return { :accum => accum, :status => :oob } if pc >= instructions.length 
   seen[pc] = true

   case instructions[pc][:opcode]
     when 'nop'
     pc += 1
   when 'jmp'
     pc += instructions[pc][:operand]
   when 'acc'
    accum += instructions[pc][:operand]
    pc += 1
   end
 end

end


def part2( instructions )

 switch = { 'jmp' => 'nop', 'nop' => 'jmp' }
 instructions.each_with_index do |ins,index|
   if switch.key?( ins[:opcode] )
      old = ins[:opcode]
      instructions[index][:opcode] = switch[ins[:opcode]]
      result = run( instructions )
      if result[:status] == :oob
        return result[:accum]
      end
     instructions[index][:opcode] = old
   end
  end
end


instructions = []
ARGF.each_line do |line|
   opcode, operand = line.chomp.scanf("%s %d")
   instructions << { :opcode => opcode, :operand => operand }
end

puts "part 1: #{run(instructions)[:accum]}"
puts "part 2: #{part2(instructions)}"
