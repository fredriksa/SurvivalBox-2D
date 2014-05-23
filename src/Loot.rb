class Loot
  WIDTH = 32
  HEIGHT = 32

  attr_reader :content, :width, :height, :x, :y

  def initialize(window, x, y, angle = 0, content = nil)
  	@x, @y = x, y
  	@window = window
    @angle = angle
    @width, @height = WIDTH, HEIGHT

    if content == nil
      generate
    else
      @content = content
      @image = Gosu::Image.new(@window, "assets/weapons/" + @content.name + "_loot.bmp", false)
    end
  end

  def update
  end

  def draw
    if @image != nil
  	  @image.draw_rot(@x, @y, ZOrder::World_Loot, @angle)
    end
  end

  def generate
    random_number = rand(1..3)
    case random_number
    when 1
      @image = Gosu::Image.new(@window, "assets/weapons/fiveseven_loot.bmp", false)
      @content = Fiveseven.new(@window, @x, @y, rand(5..10), @angle)
    when 2
      @image = Gosu::Image.new(@window, "assets/weapons/famas_loot.bmp", false)
      @content = Famas.new(@window, @x, @y, rand(10..30), @angle)
    when 3
      @image = Gosu::Image.new(@window, "assets/weapons/famas_loot.bmp", false)
      @content = M4A1.new(@window, @x, @y, rand(15..25), @angle)
    end
  end
end