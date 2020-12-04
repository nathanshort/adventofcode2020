#!/usr/bin/env ruby

all_fields = { 'byr' => -> (v) { (1920..2002).cover?( v.to_i ) },
	       'iyr' => -> (v) { (2010..2020).cover?( v.to_i ) },
	       'eyr' => -> (v) { (2020..2030).cover?( v.to_i ) },
	       'hgt' => -> (v) { v.match( /\A(((1[5678][0-9])|(19[0-3]))cm)|(((59)|(6[0-9])|(7[0-6]))in)\z/) },
	       'hcl' => -> (v) { v.match( /\A#[0-9a-f]{6}\z/ ) },
	       'ecl' => -> (v) { v.match( /\Aamb|blu|brn|gry|grn|hzl|oth\z/ ) },
	       'pid' => -> (v) { v.match( /\A[0-9]{9}\z/ ) },		    
	       'cid' => -> (v) { true }
}

part1_valid, part2_valid = 0,0
passes = File.read( ARGV[0] ).split( /^\n/ )

passes.each do |pass|
  fields = {}
  pass.split(/\s/).each do |passfield|
    key, value = passfield.split(":")
    fields[key] = value
  end 

  has_required_fields = ( ( all_fields.keys - ['cid'] ) & fields.keys.uniq ).length == all_fields.keys.length - 1 
  part1_valid +=1 if has_required_fields
  next if ! has_required_fields  
  part2_valid +=1 if fields.select{ |k,v| all_fields[k].call(v) }.count == fields.keys.count
end

puts "part1 valid: #{part1_valid}"
puts "part2 valid: #{part2_valid}"