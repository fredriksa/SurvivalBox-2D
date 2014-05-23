class Particle
  def initialize(window, image, x, y, speed_x, speed_y, map, angle, speed_damper)
    @image = image
    @x, @y = x, y
    @vel_x, @vel_y = 0, 0
    @speed_x, @speed_y = speed_x, speed_y
    @angle = angle
    @map = map
    @speed_damper = speed_damper
  end

  def update(map)
    @map = map
  	move
  	accelerate
  end

  def accelerate
  	@vel_x = Gosu::offset_x(@angle, @speed_x)
  	@vel_y = Gosu::offset_y(@angle, @speed_y)
  end

  def move
    if @x + @vel_x < GameWindow::WIDTH && @x + @vel_x > 0 && @y + @vel_y < GameWindow::HEIGHT && @y + @vel_y > 0 
      if !(@map.get_tile(@x + @vel_x, @y + @vel_y).type == "solid")
        @x += @vel_x
        @y += @vel_y

        @x %= GameWindow::WIDTH
        @y %= GameWindow::HEIGHT

        @vel_x *= @speed_damper
        @vel_y *= @speed_damper
      end
    else
      @x += @vel_x
      @y += @vel_y

      @x %= GameWindow::WIDTH
      @y %= GameWindow::HEIGHT

      @vel_x *= @speed_damper
      @vel_y *= @speed_damper
    end
  end

  def draw
  	@image.draw(@x, @y, ZOrder::Particle)
  end
end