class Fiveseven < Weapon
  def initialize(window, x, y, ammo, angle = 90, loot = false)
    @name = "Fiveseven"
  	@window = window
  	@x, @y, @angle = x, y, angle
  	@ammo = ammo
    @loot = loot
  	@damage = 25
  	@particle = 10

  	@speed = 20
    @time_since_last_shot = 0

    @image = Gosu::Image.new(window, "assets/weapons/fiveseven.bmp", false)
    @shoot_sound = Gosu::Sample.new(window, "assets/sfx/weapons/fiveseven_fire.wav")
    @click_sound = Gosu::Sample.new(window, "./assets/sfx/weapons/click.wav")
    
    @bullets = []
  end
end