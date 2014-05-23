class Play
  def initialize(window, state_manager = nil)
    @window = window
    @state_manager = state_manager

    @images_pointer = Gosu::Image::load_tiles(window, "assets/pointer.bmp", 23, 23, false)
    @pointer_index = 1
    
    @map_index = 0
    @maps = []
    @maps << Map.new(window, "test", 0, 0, 19, 8)
    @maps << Map.new(window, "zone_1", 1, 12, 0, 0)

    @player = Player.new(window, 50, 50, @maps[0])

    @GUI = GUI.new(window, @player)
    @ambient = Gosu::Sample.new(window, "assets/sfx/ambient.ogg")
    @change_map_counter = 0
  end

  def update
    if !@player.alive
      @state_manager.previous
    end

    @player.update(@window, @maps[@map_index])
    @player.move
    @GUI.update(@player)

    @maps[@map_index].zombies.each do |zombie|
      zombie.update(@player)
    end
    
    if @player.weapon != nil
      @player.weapon.bullets.each_with_index do |bullet, bullet_index|
        @maps[@map_index].zombies.each_with_index do |zombie, zombie_index|
          if bullet.alive == true && zombie.alive == true
            if Collision::rectangle?(bullet, zombie)
              zombie.receive_damage(@player.weapon.damage)
              @maps[@map_index].particle_emitters << ParticleEmitter.new(@window, zombie.x, zombie.y, zombie.angle + 180, 18, 8, 15, 16, 15, 16, 1, "assets/blood_particle.png", @maps[0], 1, @player.weapon.particle)
              if zombie.alive == false
                p @maps[@map_index].zombies.at(zombie_index)
                @maps[@map_index].zombies.delete_at(zombie_index)
              end

              bullet.die
              @player.weapon.bullets.delete_at(bullet_index)
            end
          end
        end
      end

      @player.weapon.bullets.each_with_index do |bullet, bullet_index|
        if @maps[@map_index].get_tile(bullet.x, bullet.y).type == "solid"
          bullet.die
          bullet.hit(@maps[@map_index].get_tile(bullet.x, bullet.y).material)
          @player.weapon.bullets.delete_at(bullet_index)
        end
      end
    end


    @maps[@map_index].particle_emitters.each do |emitter|
      emitter.update(@maps[@map_index])
    end
    
    @maps[@map_index].loot.each_with_index do |loot, loot_index|
      if Collision::rectangle?(loot, @player)
        if @player.pickup_counter >= 60
          if @player.weapon == nil
            @player.give_weapon(loot.content)
            @maps[@map_index].loot.delete_at(loot_index)
            @player.pickup_counter = 0
          end
        end
      end
    end

    if @change_map_counter != 180
      @change_map_counter += 1
    end

    if @player.get_tile_x == @maps[@map_index].leave_x && @player.get_tile_y == @maps[@map_index].leave_y
      if @change_map_counter == 180
        @map_index += 1
        @player.x = @maps[@map_index].tile(@maps[@map_index].enter_x) - Player::WIDTH
        @player.y = @maps[@map_index].tile(@maps[@map_index].enter_y) + (Player::WIDTH/2)
        @change_map_counter = 0
      end
    end

    if @player.get_tile_x == @maps[@map_index].enter_x && @player.get_tile_y == @maps[@map_index].enter_y
      if @change_map_counter == 180
        @map_index -= 1
        @player.x = @maps[@map_index].tile(@maps[@map_index].leave_x) - Player::WIDTH
        @player.y = @maps[@map_index].tile(@maps[@map_index].leave_y) + (Player::WIDTH/2)
        @change_map_counter = 0
      end
    end
  end

  def draw
    @images_pointer[@pointer_index].draw(@window.mouse_x, @window.mouse_y, ZOrder::GUI_Important)
    
    @maps[@map_index].draw
    @player.draw

    @maps[@map_index].zombies.each do |zombie|
      zombie.draw
    end

    @maps[@map_index].particle_emitters.each do |emitter|
      emitter.draw
    end

    @GUI.draw
    @maps[@map_index].loot.each do |loot|
      loot.draw
    end
  end

  def handle_input(key, type)
    if type == "up"
      case key
      when Gosu::KbW
        @player.KbW = false
      when Gosu::KbSpace
        @player.KbSpace = false
        @player.KbSpace_updated = true
      when Gosu::KbG
        if @player.weapon != nil
          @maps[@map_index].loot << Loot.new(@window, @player.x, @player.y, @player.angle, @player.weapon)
          @player.weapon = nil
        end
      end
    elsif type == "down"
      case key
      when Gosu::KbW
        @player.KbW = true
      when Gosu::KbSpace
        @player.KbSpace = true
      end
    end
  end

  def on_load
    @ambient_instance = @ambient.play(0.4, 1, true)
    if !@player.alive
      @state_manager.previous
    end
  end

  def on_exit
    @ambient_instance.stop
  end
end
