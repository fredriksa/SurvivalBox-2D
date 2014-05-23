class Zombie
  WIDTH, HEIGHT = 32, 32
  attr_accessor :x, :y, :angle, :alive, :width, :height

  def initialize(window, x, y, map, angle = 0)
    @window = window
    @width, @height = 32, 32
  	@x, @y = x, y
    @angle = angle
    @offset_x, @offset_y = 0.5, 0.5
    @map = map
    @alive = true
    @died = false
  	
    @speed = 1
    @vel_x, @vel_y = 0, 0

    @damage = 15
    @attack_speed = 2
    @attack_timer = 0
    @health = 100

  	@images = Gosu::Image::load_tiles(window, "assets/zombie.bmp", 32, 32, false)
  	@images << Gosu::Image.new(window, "assets/blood.png", false)
  	@image_counter = 3

    @die_sound = Gosu::Sample.new(window, "assets/sfx/zombie/die.wav")
    @attack_sound = Gosu::Sample.new(window, "assets/sfx/zombie/attack.wav")
  end

  def update(target)
    if @health <= 0 && @died == false
      self.die
      @died = true
      @alive = false

      @map.particle_emitters << ParticleEmitter.new(@window, @x, @y, @angle + 180, 18, 8, 15, 16, 15, 16, 1, "assets/blood_particle.png", @map, 1, 150)
    end

  	if @alive == true
      vector_x = target.x - @x
      vector_y = target.y - @y
      @angle = Math.atan2(vector_y, vector_x) * (180/3.14) + 90

      if vector_x.abs > (WIDTH/2) || vector_y.abs > (HEIGHT/2)
        move
      else
        if @attack_timer > @attack_speed*60
          attack(target)
          @attack_timer = 0
        end
      end

      @attack_timer += 1

      accelerate
  	end
  end

  def draw
    if @alive == true
  	  @images[@image_counter].draw_rot(@x, @y, ZOrder::Zombie, @angle)
    end
  end
  
  def accelerate
    @vel_x = Gosu::offset_x(@angle, @speed)
    @vel_y = Gosu::offset_y(@angle, @speed)
  end

  def move
    if !(@map.get_tile(@x + @vel_x, @y).type == "solid")
      @x += @vel_x
      @x %= GameWindow::WIDTH
      @vel_y *= 0.95
    end

    if !(@map.get_tile(@x, @y + @vel_y).type == "solid")
      @y += @vel_y
      @y %= GameWindow::HEIGHT
      @vel_y *= 0.95
    end
  end

  def die
    @alive = false
    @image_counter = 6
    @die_sound.play(0.6)
  end

  def attack(target)
    if target.type == "player" or target.type == "npc"
      @attack_sound.play(0.6)
      target.receive_damage(@damage)
    end
  end

  def receive_damage(damage)
    if @health - damage < 0
      @health = 0
    else
      @health -= damage
    end
  end
end