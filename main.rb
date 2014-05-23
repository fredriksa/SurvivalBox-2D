require 'Gosu'

require_relative 'src/GameStateManager.rb'
require_relative 'src/GameStates.rb'
require_relative 'src/Player.rb'
require_relative 'src/Weapon.rb'
require_relative 'src/Bullet.rb'
require_relative 'src/Button.rb'
require_relative 'src/Menu.rb'
require_relative 'src/Map.rb'
require_relative 'src/Tile.rb'
require_relative 'src/Zombie.rb'
require_relative 'src/Zombie_Target.rb'
require_relative 'src/Particle.rb'
require_relative 'src/ParticleEmitter.rb'
require_relative 'src/GUI.rb'
require_relative 'src/Loot.rb'

require_relative 'src/ResourceManager.rb'
require_relative 'src/gamestates/mainmenu.rb'
require_relative 'src/gamestates/play.rb'

require_relative 'src/weapons/m4a1.rb'
require_relative 'src/weapons/Fiveseven.rb'
require_relative 'src/weapons/Famas.rb'

require_relative 'src/Ruby/Hash.rb'

module ZOrder
  GUI_Important = 76000
  GUI_Text = 7520
  GUI_Overlay = 7510
  GUI_Body = 7500
  World_Wall = 5500
  Player_Weapon = 5020
  Player = 5000
  Zombie = 4990
  Bullet = 4900
  Particle = 4550
  World_Loot = 4505
  World_Ground = 4500
end

module Collision
  def self.rectangle?(object1, object2)
    object1_half_width = object1.width / 2
    object1_half_height = object1.height / 2
    object1_left = object1.x - object1_half_width
    object1_right = object1.x + object1_half_width
    object1_top = object1.y - object1_half_height
    object1_bottom = object1.y + object1_half_height
 
    object2_half_width = object2.width / 2
    object2_half_height = object2.height / 2
    object2_left = object2.x - object2_half_width
    object2_right = object2.x + object2_half_width
    object2_top = object2.y - object2_half_height
    object2_bottom = object2.y + object2_half_height
 
    ((object1_left >= object2_left && object1_left <= object2_right) || (object2_left >= object1_left && object2_left <= object1_right)) &&
    ((object1_top >= object2_top && object1_top <= object2_bottom) || (object2_top >= object1_top && object2_top <= object1_bottom))
  end
end

class GameWindow < Gosu::Window 
  WIDTH, HEIGHT, FULLSCREEN, NAME = 640, 480, false, "SurvivalBox 2D"

  def initialize
    super WIDTH, HEIGHT, FULLSCREEN
    self.caption = NAME
    
    @state_manager = GameStateManager.new(self)
    @state_manager.add(MainMenu.new(self, @state_manager))
    @state_manager.add(Play.new(self, @state_manager))
  end

  def update
  	@state_manager.update
  end

  def draw
  	@state_manager.draw
  end

  def button_down(id)
    @state_manager.handle_input(id, "down")
  end

  def button_up(id)
    if id == Gosu::KbN
      @state_manager.next
    elsif id == Gosu::KbP
      @state_manager.previous
    end
    @state_manager.handle_input(id, "up")
  end
end

Game = GameWindow.new
Game.show