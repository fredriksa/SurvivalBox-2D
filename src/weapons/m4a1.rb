class M4A1 < Weapon
  def initialize(window, x, y, ammo, angle = 90, loot = false)
    @name = "M4A1"
  	@window = window
    @x, @y, @angle = x, y, angle
    @ammo = ammo
    @loot = loot
    @damage = 40
    @particle = 35

    @speed = 6
    @time_since_last_shot = 0
    
    @image = Gosu::Image.new(window, "assets/weapons/m4a1.bmp", false)
    @shoot_sound = Gosu::Sample.new(window, "assets/sfx/weapons/m4a1_fire.wav")
    @click_sound = Gosu::Sample.new(window, "./assets/sfx/weapons/click.wav")
    
    @bullets = []
  end
end