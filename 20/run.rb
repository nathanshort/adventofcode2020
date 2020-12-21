#!/usr/bin/env ruby

require_relative '../lib/common'

# Grid::edges will return the edges clockwise starting at the top.
# so, for each edge, we keep track of
#   * its grid id
#   * its orientation, with 0 being at the top then going clockwise
#   * the grid that contains this edge
#
# The logic of this whole program is then
#  1. pick any image - it will be the starting image
#  2. for each of its edges, find a matching edge whereby the matching edge's is the 
#     opposite orientation of the edge.  for example, if the edge is pointing north, 
#     then find a matching edge ( if there is one - it might be a terminal edge ) that
#     is on a different grid, and, pointing south
#  3. repeat till we've hit done all ids

def save_edges( all_edges, grid, id )
  grid.edges.each_with_index do |edge,index|
    all_edges[edge] ||= []
    all_edges[edge] << { :id => id, :orientation => index, :grid => grid }
  end
  vflip = grid.vflip
  vflip.edges.each_with_index do |edge,index|
    all_edges[edge] ||= []
    all_edges[edge] << { :id => id, :orientation => index, :grid => vflip }
  end
  hflip = grid.hflip
  hflip.edges.each_with_index do |edge,index|
    all_edges[edge] ||= []
    all_edges[edge] << { :id => id, :orientation => index, :grid => hflip }
  end
end

all_edges = {}
starter = nil
num_grids = 0
ARGF.read.split(/\n\n/).each do |d|
  iddata, griddata = d.split(/:\n/)
  grid = Grid.new( :io => griddata.chomp )
  id = iddata.scan(/\d+/)[0].to_i
  save_edges( all_edges, grid, id )
  to_rotate = grid
  3.times do
    rotated = to_rotate.rotate
    save_edges( all_edges, rotated, id )
    to_rotate = rotated
  end
  num_grids += 1
  # save the first one we see. we will seed the picture building with it
  starter = { :id => id, :grid => grid } if ! starter
end

# the picture ( with edges ) - keyed by its location ( a Point )
picture = {} 

# put the starter at 0,0;  we could put it anywhere - its all relative
picture[Point.new(0,0)] = { :id => starter[:id], :grid => starter[:grid] }

# keep track of which ids we've already placed on the picture  
ids_placed = { starter[:id] => true }

# this is the list of points that we will find neighbors for 
points_to_eval = [picture.keys.first]

# when we find a neighbor, we want it to be opposite the edge we are looking for
# as Grid::edge returns in clockwise order, starting at north ( index 0 ), we then for   
# example want to find a match opposite it ( at index 2 )
opposite = [2,3,0,1]

# tells us where to place the adjacent picture.  if we found a match on the northern edge
# ( index 0 ), then we'd move the y up by 1 and the x by 0
offsets = [ Point.new(0,1), Point.new(1,0), Point.new(0,-1), Point.new(-1,0)]

while ids_placed.keys.count != num_grids 
  evaluating_point = points_to_eval.first
  evaluating = picture[evaluating_point]
  next_to_eval = []
  evaluating[:grid].edges.each.with_index do |edge,index|
    neighbor = all_edges[edge].detect { |e| ( e[:id] != evaluating[:id] ) && ( e[:orientation] == opposite[index] ) }
    next if ( ! neighbor || ids_placed.key?( neighbor[:id] ) )
    location = Point.new( evaluating_point.x + offsets[index].x, evaluating_point.y + offsets[index].y )
    ids_placed[neighbor[:id]] = true
    picture[location] = { :id => neighbor[:id], :grid => neighbor[:grid] }
    next_to_eval << location
  end
  points_to_eval.shift
  points_to_eval |= next_to_eval
end

xrange = picture.keys.map{ |point| point.x }.minmax
yrange = picture.keys.map{ |point| point.y }.minmax
part1 = xrange.product( yrange ).inject(1) {|product,pair| product *= picture[Point.new(pair.first, pair.last)][:id] }
puts "part1: #{part1}"

master_grid = Grid.new
xoffset = 0 
(xrange.first..xrange.last).each do |x|
  yoffset = 0
  # reverse_each as Grid currently treats down as positive y
  (yrange.first..yrange.last).reverse_each do |y|
    g = picture[Point.new(x,y)][:grid]
    g.each do |point,value|
      # skip the framing
      next if point.x == 0 || point.y == 0 || point.x == ( g.width - 1 ) || point.y == ( g.height - 1 )
      master_grid[Point.new( xoffset + point.x - 1, yoffset + point.y - 1 )] = value
    end
    yoffset += starter[:grid].height - 2
  end
  xoffset += starter[:grid].width - 2
end

monster = [[18],[0,5,6,11,12,17,18,19],[1,4,7,10,13,16]]
monster_width = 20
monster_height = 3

# try to find the monsters in all combinations of rotations and flips
[ master_grid, master_grid.rotate, master_grid.rotate.rotate, master_grid.rotate.rotate.rotate ].each do |grid|
  [ grid, grid.hflip, grid.vflip ].each do |gg|
    num_monsters = 0
    (0..gg.height - monster_height - 1).each do |y|
      (0..gg.width - monster_width - 1).each do |x|
        if monster[0].all?{|offset| gg[Point.new(x+offset,y)] == '#'} &&
           monster[1].all?{|offset| gg[Point.new(x+offset,y+1)] == '#'} &&
           monster[2].all?{|offset| gg[Point.new(x+offset,y+2)] == '#'} 
            num_monsters += 1
        end
      end
    end
    if num_monsters != 0
      puts "part2: #{gg.count{|point,value| value == '#'} - num_monsters*(monster.flatten.count)}"
      exit
    end
  end 
end
