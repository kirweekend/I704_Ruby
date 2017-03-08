require 'gosu'
require_relative 'player'

module Game
  class Space < Gosu::Window
    WIDTH = 960
    HEIGHT = 720
    PLAYER_WIDTH = 480
    PLAYER_HEIGHT = 360
    def initialize
      super(WIDTH, HEIGHT)
      self.caption = "Space Game"
      @background_image = Gosu::Image.new("assets/sky.jpg", :tileable => true)
      @player = Player.new(self)
      @player.size(PLAYER_WIDTH, PLAYER_HEIGHT)
    end

    def draw
      @player.draw()
      @background_image.draw(0,0,0)
    end

    def update
      if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::KB_A
        @player.turn_left
      end
      if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::KB_D
        @player.turn_right
      end
      if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::KB_W
        @player.accelerate
      end
      @player.move
    end
  end
end

Game::Space.new.show
