class LevelEditor
  def initialize(window, state_manager)
  	@window = window
  	@state_manager = state_manager
  end

  def update
  end

  def draw
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

  end

  def on_exit

  end
end