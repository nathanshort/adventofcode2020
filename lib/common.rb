
class PointNd

  attr_reader :components

  def initialize( components )
    @components = components
  end

  def ==(other)
    @components == other.components
  end

  alias eql? ==
      
  def hash
    hash = nil
    components.each do |c|
      hash = ( hash ? hash ^ c.hash : c.hash )
    end
    hash
  end  

  def adjacent
    if ! @adjacent
      @adjacent = []
      product_operands = []
      ( @components.count - 1 ).times do 
       product_operands << [-1,0,1]
      end
      cartesian = [-1,0,1].product( *product_operands )
      cartesian.each do |p|
        new_components = []
        @components.each_with_index do |c,index|
        new_components[index] = c + p[index]
      end
      p = PointNd.new( new_components)
      @adjacent << p if p != self
      end
    end
    @adjacent
  end

end


class Point 

  attr_accessor :x, :y
  
  def initialize( x, y )
    @x, @y = x, y
  end
  
  def ==(other)
    other.x == @x && other.y == @y 
  end
  
  alias eql? ==
        
  def hash
    @x.hash ^ @y.hash
  end  

  def <=>( other )
    ysort = ( @y <=> other.y )
    xsort = ( @x <=> other.x )
    ysort != 0 ? ysort : xsort 
  end

  def adjacent() 
    @adj ||= 
    [ Point.new( @x - 1, @y ),
      Point.new( @x - 1, @y - 1 ),
      Point.new( @x, @y - 1 ),
      Point.new( @x + 1, @y - 1 ),
      Point.new( @x + 1, @y ),
      Point.new( @x + 1, @y + 1 ),
      Point.new( @x, @y + 1 ),
      Point.new( @x - 1, @y + 1 )
    ]
    @adj
   end

end


class Cursor

  attr_reader :location

  def initialize( args )
    @heading = args[:heading]
    @location = Point.new( args[:x] || 0, args[:y] || 0 )
  end

  def move( args )
    case args[:direction]
      when 'N'
        @location.y += args[:by]
      when 'S'
        @location.y -= args[:by]
      when 'W'
         @location.x -= args[:by]
      when 'E'
        @location.x += args[:by]
      end
  end

  def turn( args )
    turns = %w[N E S W]
    case args[:direction]
      when 'L'
        @heading = turns[ turns.index( @heading ) - 1 ]
      when 'R'
        @heading = turns[ ( turns.index( @heading ) + 1 ) % turns.count ]
    end
  end

  def forward( args )
    factor = { 'N' => 1, 'S' => -1, 'E' => 1, 'W' => -1}
    case @heading
      when 'N','S' 
        @location.y += args[:by] * factor[@heading]
      when 'E','W'
        @location.x += args[:by] * factor[@heading]
    end
  end

  def rotate( args )
    case args[:direction]
      when 'L'
        tmp = @location.dup
        @location.x = -tmp.y
        @location.y = tmp.x
      when 'R'
        tmp = @location.dup
        @location.x = tmp.y
        @location.y = -tmp.x
    end
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

  # returns a new grid rotated 90deg clockwise.  current grid is untouched
  def rotate
    g = Grid.new
    self.each do |point,v|
      g[Point.new(point.y,point.x)] = v
    end
    (0..g.height - 1).each do |y|
      ( 0..g.width/2.ceil - 1 ).each do |x|
        tmp = g[Point.new(x,y)]
        g[Point.new(x,y)] = g[Point.new(g.width - x - 1, y )]
        g[Point.new(g.width - x - 1,y)] = tmp
      end
    end
    g
  end

  # flip around the horizontal center row.  returns a new grid
  def hflip
    g = Grid.new
    self.each do |point,v|
      g[Point.new( @width - point.x - 1, point.y )] = v 
    end
    g
  end

  # flip around the vertical center row.  returns a new grid
  def vflip
    g = Grid.new
    self.each do |point,v|
      g[Point.new( point.x, @height - point.y - 1 )] = v 
    end
    g
  end

  # returns edges as array of array of points.  edges are 
  # returned starting at the top, in clockwise order
  def edges
    h = hedges
    v = vedges
    [ h[0], v[1], h[1], v[0] ]
  end

  # vertical edges
  def vedges
    [0,@width-1].map do |x|
      ( 0..@height-1 ).map{ |y| @points[Point.new(x,y)] }
    end
  end

  # horizontal edges
  def hedges
    [0,@height-1].map do |y|
      ( 0..@width-1 ).map{ |x| @points[Point.new(x,y)] }
    end
  end

  def show
   (0..(height - 1) ).each do |y|
     (0..(width - 1) ).each do |x| 
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


