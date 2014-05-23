class Button
  WIDTH, HEIGHT = 220, 103
  attr_reader :x, :y, :title
  attr_accessor :clicked

  def initialize(window, x, y, title)
  	@x, @y = x, y
  	@title = title
    @clicked = false
  	@font_size = 24
    @font = Gosu::Font.new(window, "Grobold.ttf", @font_size)

    @images = []
    @images << Gosu::Image.new(window, "assets/button_inactive.png", false)
    @images << Gosu::Image.new(window, "assets/button_hover.png", false)
    @images << Gosu::Image.new(window, "assets/button_click.png", false)
    @image_counter = 0
  end

  def update
  end

  def draw
  	@images[@image_counter].draw(@x, @y, ZOrder::GUI_Overlay)
  	@font.draw(@title, @x + (@Button::WIDTH/2) - (@font.text_width(@title)/2) - @font_size, @y + (Button::HEIGHT/2) - @font_size, ZOrder::GUI_Text)
  end

  def on_hover
    if @clicked == false
      @image_counter = 1
    end
  end

  def on_click
    @image_counter = 2
  end

  def on_inactive
    @image_counter = 0
  end
end