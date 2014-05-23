class ParticleEmitter
  attr_accessor :alive

  def initialize(window, x, y, angle, spread_x, spread_y, min_speed_x, max_speed_x, min_speed_y, max_speed_y, life_time, image_path, map, speed_damper = 1, density = 25)
  	@window = window
  	@x, @y, @angle = x, y, angle
  	@min_speed_x, @max_speed_x, @min_speed_y, @max_speed_y = min_speed_x, max_speed_x, min_speed_y, max_speed_y
  	@image = Gosu::Image.new(window, image_path, false)
    @map = map
    @speed_damper = speed_damper
    
    @alive = true
    @life_time = life_time*60
    @time_counter = 0
  	
  	@particles = []
  	density.times do 
      @particles << Particle.new(window, @image, rand(@x-spread_x..@x+spread_x), rand(@y-spread_y..@y+spread_y), rand(@min_speed_x..@max_speed_x), rand(@min_speed_y..@max_speed_y), @map, @angle, @speed_damper)  
  	end
  end

  def update(map)
  	if @time_counter >= @life_time
      @alive = false
  	end

  	if @alive == true
  	  @particles.each do |particle|
      particle.update(map)
  	end

  	@time_counter += 1
  end
  end

  def draw
  	if @alive == true
      @particles.each do |particle|
        particle.draw
      end
  	end
  end
end