#!/usr/bin/env ruby

memory1, memory2 = {}, {}
and_mask, or_mask = nil, nil
x_spots = []

ARGF.each_line do |line|
  line.chomp!
  if match = line.match( /\Amask = (?<mask_value>.*)\z/ )
     and_mask = ( 2 ** 36 ) - 1   
     or_mask = 0
     x_spots = []
     match['mask_value'].chars.reverse_each.with_index do |c,index|
        and_mask &= ~( 1 << index ) if c == '0'
        or_mask |= ( 1 << index ) if c == '1'
        x_spots << index if c == 'X'
     end 
  elsif match = line.match( /\Amem\[(?<address>\d+)\] = (?<value>\d+)\z/ )
     memory1[match['address']] = and_mask & match['value'].to_i | or_mask
     original_base_address = match['address'].to_i | or_mask
     ( 2 ** x_spots.count ).times do |iteration|
      xmask = sprintf( "%036B", iteration )
      base_address = original_base_address
      x_spots.each_with_index do |spot,spot_index|
        value_to_set = xmask.chars.reverse[spot_index].to_i
        base_address |= (1 << spot ) if value_to_set == 1
        base_address &= ~(1 << spot ) if value_to_set == 0
      end
      memory2[base_address] = match['value'].to_i
     end 
  end
end

p memory1.values.inject( 0 ) { |sum,x| sum += x }
p memory2.values.inject( 0 ) { |sum,x| sum += x }
