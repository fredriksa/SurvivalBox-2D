class Bullet
  attr_reader :alive, :x, :y, :width, :height
  WIDTH, HEIGHT = 3, 6

  def initialize(window, x, y, angle, damage, speed = 15, size = 1)
    @width, @height = WIDTH, HEIGHT
  	@x, @y, @angle = x, y, angle
  	@image = Gosu::Image.new(window, "assets/bullet.png", false)
    @ricochet_sounds = []
    @ricochet_sounds << Gosu::Sample.new(window, "assets/sfx/ricochet/metal1.wav")
    @ricochet_sounds << Gosu::Sample.new(window, "assets/sfx/ricochet/metal2.wav")

  	@vel_x, @vel_y = 0
  	@speed = speed
  	@alive = true
  end

  def update
  	if @alive == true
  	  if @x > GameWindow::WIDTH - Bullet::WIDTH - (@speed/2) || @x < 0 + Bullet::WIDTH + (@speed/2)  || @y - Bullet::HEIGHT - (@speed/2)  < 0 || @y + Bullet::HEIGHT + (@speed/2) > GameWindow::HEIGHT
        @alive = false
  	  end

      move
  	end
  end

  def draw
  	if @alive == true
      @image.draw_rot(@x, @y, ZOrder::Bullet, @angle)
  	end
  end

  def move
  	@vel_x = Gosu::offset_x(@angle, @speed)
  	@vel_y = Gosu::offset_y(@angle, @speed)

    @x += @vel_x
    @y += @vel_y

    @x %= GameWindow::WIDTH
    @y %= GameWindow::HEIGHT
  end

  def die
    @alive = false
  end

  def hit(material)
    case material
    when "metal"
      @ricochet_sounds[rand(0..1)].play
    end
  end
end