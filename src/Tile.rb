class Tile
  WIDTH, HEIGHT = 32, 32

  attr_reader :x, :y, :id
  attr_accessor :type, :material  
  
  def initialize(window, x, y, image, id, type, material, z_order)
    @width, @height = 32, 32
  	@x, @y = x, y
  	@image = image
    @id = id
    @type, @material = type, material
    @z_order = z_order
  end

  def update
  end

  def draw
  	@image.draw(@x, @y, @z_order)
  end
end