class Menu
  WIDTH, HEIGHT = 424, 575
  attr_reader :x, :y

  def initialize(window, x, y, title)
    @window = window
  	@x, @y = x, y
    @title = title
    @font_size = 35
    @font = Gosu::Font.new(window, "Grobold.ttf", @font_size)
    @image = Gosu::Image.new(window, "assets/menu_body.png", false)
    @buttons = []
  end

  def update(window, state_manager)
    @buttons.each do |button|
      if window.mouse_x < button.x || window.mouse_x > button.x + Button::WIDTH || window.mouse_y < button.y || window.mouse_y > button.y + Button::HEIGHT
        button.on_inactive
      else
        button.on_hover
        if window::button_down? Gosu::MsLeft
          button.on_click
          button.clicked = true

          if button.title == "Play"
            state_manager.next
          end
        else
          if button.clicked == true
            button.clicked = false
          end
        end
      end
    end
  end

  def draw
  	@image.draw(@x, @y, ZOrder::GUI_Body)
    @buttons.each do |button|
      button.draw
    end

    @font.draw(@title, (@x + @font.text_width(@title)/2) - 50, 50 - (@font_size/5), ZOrder::GUI_Text)
  end

  def add_button(window, title)
    if @buttons.size > 0
      button = Button.new(window, @x + 80, @y + 90 + ((10 + Button::HEIGHT) * @buttons.size), title)
    else
      button = Button.new(window, @x + 80, @y + 90, title)
    end

    @buttons << button
  end
end