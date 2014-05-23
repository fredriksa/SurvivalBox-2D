#
# MAP
#
# IMPORTANT: The tiles are loaded in an (Y, X) format.
# IMPORTANT: The tiles are stored in an (X, Y) format.
#
# Tilepack ID - RANGE
# 1 - 0 to 35 
# 2 - 36 to 163
# 3 - 164 to 299

class Map
  attr_reader :enter_x, :enter_y, :leave_x, :leave_y, :tiles, :loot
  attr_accessor :zombies, :tiles, :particle_emitters

  def initialize(window, filepath, enter_x = 0, enter_y = 0, leave_x = 0, leave_y = 0)
    @window = window
    @tiles = []
    @images = []
    @zombies = []
    @loot = []
    @particle_emitters = []

    @images << Gosu::Image::load_tiles(window, "assets/tilepack1.bmp", 32, 32, false)
    @images << Gosu::Image::load_tiles(window, "assets/tilepack2.bmp", 32, 32, false)
    @images << Gosu::Image::load_tiles(window, "assets/tilepack3.bmp", 32, 32, false)
    @images.flatten!
    @enter_x, @enter_y, @leave_x, @leave_y = enter_x, enter_y, leave_x, leave_y

    self.load(filepath)
    @tiles.flatten.each_with_index do |tile|
      if tile.type != "solid"
        if rand(1..100) > 97
          @zombies << Zombie.new(window, tile.x, tile.y, self)
        end
      end
    end

    @tiles.flatten.each_with_index do |tile|
      if tile.type != "solid"
        if rand(1..1000) > 990
          @loot << Loot.new(window, tile.x + Tile::WIDTH/2, tile.y + Tile::HEIGHT/2)
        end
      end
    end
  end

  def update
  end

  def draw
    @tiles.each_with_index do |array, outer|
      array.each_with_index do |tile, inner|
        tile.draw
      end
    end
  end

  def [](x, y) 
   if @tiles[x]
    return @tiles[x][y]
   else
    return nil	
   end
  end

  def []=(x, y, new_value)
    @tiles[x] ||= []
    @tiles[x][y] = new_value
  end

  def load(name)
    counter = 0
    map_data = [[], []]
    file = File.new("maps/" + name + ".data", "r")
    while (line = file.gets)
      new_data = line.split(" ")
      map_data[counter] = new_data
      counter += 1
    end
    
    type = {}
    type.add(0, 25, "background")
    type.add(36, 40, "background")
    type.add(41, 41, "solid")
    type.add(42, 42, "background")
    type.add(43, 53, "solid")
    type.add(54, 55, "background")
    type.add(56, 56, "solid")
    type.add(57, 70, "solid")
    type.add(164, 164, "background")
    type.add(165, 171, "solid")
    type.add(172, 183, "background")
    type.add(184, 187, "solid")
    type.add(188, 221, "background")
    type.add(222, 243, "solid" )
    type.add(244, 267, "background")
    type.add(268, 291, "background")
    
    material = {}
    material.add(0, 12, "dirt")
    material.add(13, 22, "wood")
    material.add(23, 23, "metal")
    material.add(24, 25, "dirt")
    material.add(36, 171, "metal")
    material.add(172, 180, "dirt")
    material.add(181, 184, "wood")
    material.add(185, 185, "metal")
    material.add(186, 187, "wood")
    material.add(188, 207, "dirt")
    material.add(208, 211, "metal")
    material.add(212, 221, "dirt")
    material.add(222, 224, "metal")
    material.add(225, 226, "wood")
    material.add(227, 227, "metal")
    material.add(228, 240, "wood")
    material.add(241, 243, "metal")
    material.add(244, 245, "wood")
    material.add(256, 264, "metal")
    material.add(265, 266, "wood")
    material.add(267, 267, "metal")
    material.add(268, 268, "wood")
    material.add(269, 269, "snow")
    material.add(270, 299, "metal")

    zorder = {}
    zorder.add(0, 299, ZOrder::World_Ground)
    zorder.add(165, 165, ZOrder::World_Wall)


    map_data.each_with_index do |array, y|
      array.each_with_index do |data, x|
       self[x, y] = Tile.new(@window, x * Tile::WIDTH, y * Tile::HEIGHT, @images[data.to_i], data.to_i, type[data.to_i], material[data.to_i], zorder[data.to_i])
      end
    end
  end

  def get_tile(x, y)
    @tiles[x/32.abs.floor][y/32.abs.floor]
  end

  def tile(id)
    id*32.abs.floor
  end 
end