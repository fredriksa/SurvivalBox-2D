class Famas < Weapon
  def initialize(window, x, y, ammo, angle = 90, loot = false)
    @name = "Famas"
  	@window = window
  	@x, @y, @angle = x, y, angle
  	@ammo = ammo
    @loot = loot
  	@damage = 30
    @particle = 30
   
    @speed = 10
    @time_since_last_shot = 0
    
    @image = Gosu::Image.new(window, "assets/weapons/famas.bmp", false)
    @shoot_sound = Gosu::Sample.new(window, "assets/sfx/weapons/famas_fire.wav")
    @click_sound = Gosu::Sample.new(window, "./assets/sfx/weapons/click.wav")

    @bullets = []
  end
end