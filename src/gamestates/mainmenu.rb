class MainMenu
  def initialize(window, state_manager)
    @window = window
    @state_manager = state_manager

    @menu = Menu.new(window, GameWindow::WIDTH/2 + 45 - Menu::WIDTH/2, GameWindow::HEIGHT/2 - Menu::HEIGHT/2 + 60, GameWindow::NAME)
    @menu.add_button(window, "Play")
    @menu.add_button(window, "Editor")
    @menu.add_button(window, "Settings")

    @music = Gosu::Sample.new(window, "assets/theme.ogg")
    @map = Map.new(window, "mainmenu")

    @zombies = []
    @zombie_target = ZombieTarget.new(GameWindow::WIDTH/2, 0)
    @zombie_timer = 60
    @zombie_counter = 0
  end

  def update
    if @zombie_timer < @zombie_counter
      @zombies << Zombie.new(@window, rand(@map.tile(1)..@map.tile(19)), @map.tile(14), @map)
      @zombie_counter = 0
    end
    @zombie_counter += 1

    @zombies.each_with_index do |zombie, zombie_index|
      zombie.update(@zombie_target)

      if zombie.y - Zombie::HEIGHT < 0
        @zombies.delete_at(zombie_index)
      end
    end

    @menu.update(@window, @state_manager)
  end

  def draw
    @menu.draw
    @map.draw
    @zombies.each do |zombie|
      zombie.draw
    end
  end

  def handle_input(key, type)
    if type == "up"
      case key
      when Gosu::MsLeft
      end
    elsif type == "down"
      case key
      when Gosu::KbW
      end
    end
  end

  def on_load
    @music_sample = @music.play(0.5, 1, true)
  end

  def on_exit
    @music_sample.stop
  end
end