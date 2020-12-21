#!/usr/bin/env ruby

all_allergens = {}
all_ingredients = {}

ARGF.each_line do |line|
    match = line.chomp.match( /\A(?<ingredients>.*) \(contains (?<allergens>.*)\)/ )
    ingredients = match['ingredients'].split(/\s/)
    ingredients.each { |i| all_ingredients[i] = ( all_ingredients[i] || 0 ) + 1 }
    match['allergens'].split(/, /).each do |allergen|
        all_allergens[allergen] = ( all_allergens[allergen] || ingredients ) & ingredients
    end
end

ingredients_in_allergens = Hash[ all_allergens.values.flatten.collect{ |item| [item, true ] } ]
not_allergen_ingredients = all_ingredients.keys.select { |i| ! ingredients_in_allergens.key?( i ) }
puts "part1: #{not_allergen_ingredients.inject(0){|sum,ingredient| sum+=all_ingredients[ingredient]}}"

identified = {}
while identified.keys.count < all_allergens.keys.count
    all_allergens.select{|k,v| v.count == 1 }.each do |allergen,possibles|
        found = possibles.first
        identified[found] = allergen
        all_allergens.each { |a,items| items.reject!{|y| y == found } }
    end
end

puts "part2: #{identified.keys.sort{|a,b| identified[a] <=> identified[b]}.join(',')}"
