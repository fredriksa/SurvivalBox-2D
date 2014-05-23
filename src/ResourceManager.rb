class ResourceManager
  def initialize(window)
  	@window = window
    @resources = Hash.new
  end
  
  def load(key, filename, type)
  	case type
  	when "image"
  	  @resources[key] = Gosu::Image.new(@window, "assets/" + filename, false)	
  	end
  end

  def get_image(key)
    return @resources[key]
  end
end