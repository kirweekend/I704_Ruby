require 'gosu'
require_relative 'player'
require_relative 'bullet'

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
      @bullets = []
      @beep = Gosu::Sample.new "assets/shoot.ogg"
    end

    def button_down(id)
      if id == Gosu::KbSpace
        @bullets.push(Bullet.new(self, @player.x, @player.y, @player.angle))
        @beep.play
      end
    end

    def draw
      @player.draw()
      @bullets.each(&:draw)
      @background_image.draw(0,0,0)
    end

    def update
      @player.turn_left if button_down?(Gosu::KB_A)
      @player.turn_right if button_down?(Gosu::KB_D)
      @player.accelerate if button_down?(Gosu::KB_W)
      @player.move
      @bullets.each(&:move)
      @bullets.each do |bullet|
        @bullets.delete bullet unless bullet.onscreen?
      end
    end
  end
end

Game::Space.new.show
