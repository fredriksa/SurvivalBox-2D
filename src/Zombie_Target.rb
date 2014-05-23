class ZombieTarget
  attr_accessor :x, :y, :type
  def initialize(x, y)
    @x, @y = x, y
    @type = "invisible"
  end
end