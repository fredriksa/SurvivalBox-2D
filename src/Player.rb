class Player
  WIDTH = 32
  HEIGHT = 32

  attr_accessor :KbW, :KbSpace, :KbSpace_updated, :x, :y, :weapon, :health, :width, :height, :health, :type, :angle, :pickup_counter
  attr_reader :alive

  def initialize(window, x, y, map, angle = 90)
    @width, @height = 32, 32
    @window = window
  	@x, @y, @angle = x, y, angle
    @map = map
    @type = "player"
    @weapon = nil
    @alive = true

    @speed, @vel_x, @vel_y = 1.5, 0, 0
    @health = 100

    @image = Gosu::Image::load_tiles(window, "assets/player.bmp", 32, 32, false)
    @image_index = 5
    @hit_sounds = []
    @hit_sounds << Gosu::Sample.new(window, "./assets/sfx/player/zombie_hit.wav")
    @click_sound = Gosu::Sample.new(window, "./assets/sfx/weapons/click.wav")

    @walk_sounds = []
    @sound_paths = Dir.entries("./assets/sfx/player/walk")
    @sound_paths.each do |path|
      if path == "." or path == ".."
        next
      end 
      @walk_sounds << Gosu::Sample.new(window, ("./assets/sfx/player/walk/" + path))
    end
    @walk_sound_timer = 15
    @walk_sound_counter = 0
    @pickup_counter = 0

    @kbSpace_updated == false
  end

  def update(window, map)
    @map = map
    if @health <= 0
      @alive = false
    end

    if @pickup_counter <= 180 && self.weapon == nil
      @pickup_counter += 1
    end

    if self.weapon == nil && @image_index != 2
      @image_index = 2
    end

    vector_x = window.mouse_x - @x
    vector_y = window.mouse_y - @y
 
    if vector_x.abs > (WIDTH/2) || vector_y.abs > (HEIGHT/2)
      move
      @angle = Math.atan2(vector_y, vector_x) * (180/3.14) + 90
      
      if @weapon != nil
        @weapon.x = @x + Gosu::offset_x(@angle, WIDTH/2) 
        @weapon.y = @y + Gosu::offset_y(@angle, HEIGHT/2)
        @weapon.angle = @angle
      end
      
      if @KbW == true
        accelerate
      end
    else
      @vel_x = 0
      @vel_y = 0
    end
    
    if @weapon != nil
      @weapon.update
    end
    
    @walk_sound_counter += 1

    if @KbSpace == true
      self.shoot
    end
  end

  def draw
  	@image[@image_index].draw_rot(@x, @y, ZOrder::Player, @angle)

    if @weapon != nil
      @weapon.draw
    end
  end

  def accelerate
    @vel_x = Gosu::offset_x(@angle, @speed)
    @vel_y = Gosu::offset_y(@angle, @speed)

    if @walk_sound_counter > @walk_sound_timer
      case @map.get_tile(@x, @y).material
      when "dirt"
        random_start = 0
        random_end = 3
      when "metal"
        random_start = 4
        random_end = 7
      when "snow"
        random_start = 8
        random_end = 11
      when "wood"
        random_start = 12
        random_end = 15
      end

      @walk_sounds[rand(random_start..random_end)].play(0.6)
      @walk_sound_counter = 0
    end
  end

  def move
    if !(@map.get_tile(@x + @vel_x, @y).type == "solid")
      @x += @vel_x
      @x %= GameWindow::WIDTH
      @vel_x *= 0.95
    end

    if !(@map.get_tile(@x, @y + @vel_y).type == "solid")
      @y += @vel_y
      @y %= GameWindow::HEIGHT
      @vel_y *= 0.95
    end
  end

  def give_weapon(weapon)
    @weapon = weapon
    @image_index = 5
  end

  def shoot
    if @weapon != nil && @weapon.ammo > 0
      @weapon.shoot(@angle)
    elsif @KbSpace_updated == true
      @click_sound.play(0.6)
      @KbSpace_updated = false
    end
  end

  def receive_damage(damage)
    if @health - damage < 0
      @health = 0
    else
      @health -= damage
    end

    @hit_sounds[0].play(0.6)
  end

  def get_tile_x
    @map.get_tile(@x, @y).x/32.abs.floor
  end

  def get_tile_y
    @map.get_tile(@x, @y).y/32.abs.floor
  end
end