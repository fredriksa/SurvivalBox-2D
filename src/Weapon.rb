class Weapon
  attr_accessor :x, :y, :angle, :bullets, :ammo, :bullets, :damage, :particle, :loot, :name

  def initialize(window, x, y, ammo, damage = 40, speed = 1, angle = 90, loot = false, particle = 10)
  	@window = window
  	@x, @y, @angle = x, y, angle
  	@ammo = ammo
  	@damage = damage
    @particle = particle
    @speed = speed*60
    @time_since_last_shot = 0
    @loot = loot

  	@image = Gosu::Image.new(window, image_path, false)

  	@bullets = []
  end

  def update
    if @bullets != nil
     @bullets.each do |bullet|
        bullet.update
      end
    end

    @time_since_last_shot += 1
  end

  def draw
    if @loot == false
      @image.draw_rot(@x, @y, ZOrder::Player_Weapon, @angle, 0.5, 0.5)
      if @bullets != nil
        @bullets.each do |bullet|
          bullet.draw
        end
      end
    end
  end

  def shoot(angle)
    if @time_since_last_shot > @speed
      @bullets << Bullet.new(@window, @x, @y, @angle, @damage)
      @shoot_sound.play(0.6)
      if @ammo-1 >= 0
        @ammo -= 1
      end	
      @time_since_last_shot = 0
    end
  end
end