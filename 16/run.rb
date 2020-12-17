#!/usr/bin/env ruby

notes = {}
File.open( 'notes.txt' ).each_line do |line|
  match = line.chomp.match(/\A(?<field>.*): (?<r11>\d+)-(?<r12>\d+) or (?<r21>\d+)-(?<r22>\d+)\z/ )
  notes[match['field']] = [ ( match['r11'].to_i..match['r12'].to_i ), ( match['r21'].to_i..match['r22'].to_i ) ]
end

tickets = []
File.open( 'nearby.txt' ).each_line do |line|
  tickets << line.chomp.split(",").map( &:to_i )
end

my_ticket = "191,139,59,79,149,83,67,73,167,181,173,61,53,137,71,163,179,193,107,197".split(",").map( &:to_i )

error_rate = 0
valid_tickets = []
tickets.each do |ticket|
  valid_ticket = true
  ticket.each do |ticket_field|
     if ! notes.values.any? {|x| x[0].cover?( ticket_field ) || x[1].cover?( ticket_field ) }
       valid_ticket = false
       error_rate += ticket_field
     end
  end
  valid_tickets << ticket if valid_ticket
end
puts "part 1: #{error_rate}"


possibles = {}
valid_tickets[0].length.times { |t| possibles[t] = notes.keys }

valid_tickets.each do |ticket|
 ticket.each.with_index do |value,index|
  notes.each do |note,ranges|
   if ! ranges[0].cover?( value ) && ! ranges[1].cover?( value )
     possibles[index].delete( note )
   end 
  end
 end
end


order = possibles.keys.sort{|a,b| possibles[a].count <=> possibles[b].count }
part2 = 1
actuals = []
order.each.with_index do |order_index,index|
  actuals[order_index] = ( index == 0 ? possibles[order[index]].first : ( possibles[order[index]] - possibles[order[index-1]] ).first ) 
  part2 *= my_ticket[order_index] if actuals[order_index].match( /departure/ )
end
puts "part 2: #{part2}"
  



