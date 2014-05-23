class GUI
  def initialize(window, object)
    @symbols = Gosu::Image::load_tiles(window, "assets/HUD/symbols.png", 32, 32, false)
    @font_size = 35
    @font = Gosu::Font.new(window, "Grobold.ttf", @font_size)
    @object = object
  end

  def update(object)
    @object = object
  end

  def draw
    @symbols[0].draw(0, GameWindow::HEIGHT-32, ZOrder::GUI_Overlay)
    @font.draw(@object.health, 40 + @font.text_width(@object.health)/2, GameWindow::HEIGHT-@font_size, ZOrder::GUI_Text )
  end
end