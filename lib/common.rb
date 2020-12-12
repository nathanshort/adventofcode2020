class Point 

  attr_accessor :x, :y
  
  def initialize( x, y )
    @x = x
    @y = y
  end
  
  def ==(other)
    other.x == @x && other.y == @y 
  end
  
  alias eql? ==
        
  def hash
    @x.hash ^ @y.hash
  end  

  def <=>( other )
    ysort = ( y <=> other.y )
    xsort = ( x <=> other.x )
    ysort != 0 ? ysort : xsort 
  end

  def adjacent() 
    @adj ||= 
    [ Point.new( self.x - 1, self.y ),
      Point.new( self.x - 1, self.y - 1 ),
      Point.new( self.x, self.y - 1 ),
      Point.new( self.x + 1, self.y - 1 ),
      Point.new( self.x + 1, self.y ),
      Point.new( self.x + 1, self.y + 1 ),
      Point.new( self.x, self.y + 1 ),
      Point.new( self.x - 1, self.y + 1 )
    ]
    @adj
   end

end


class Grid

  include Enumerable 
  attr_accessor :height, :width, :points

  def []( point )
    @points[point]
  end

  def []=(point,value)
    @points[point] = value
    @height = point.y+1 if point.y+1 > @height
    @width = point.x+1 if point.x+1 > @width 
  end

  def initialize( args = {} ) 
    @points = {}
    @width, @height = 0, 0

    if args[:io]
      args[:io].each_line.with_index do |line,y|
       line.chomp.chars.each_with_index do |c,x|
         @points[Point.new(x,y)] = c
         @width = (x+1) if @width < (x+1)
       end
       @height = (y+1) if @height < (y+1)
     end
    end
   end
  
  def initialize_copy( original )
   @points = original.points.dup
  end

  def show
   (0..(height - 1) ).each do |y|
     (0..(width-1) ).each do |x| 
       print @points[Point.new(x,y)]
     end
     print "\n"
   end
   print "\n\n"
  end

  def each( &block )
     points.keys.sort.each do |k|
       block.call( k, points[k] )
     end
  end

  def ==( other )
    other.points == @points
  end

end


