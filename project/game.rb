require 'gosu'
require_relative 'player'
require_relative 'bomb'
require_relative 'bullet'
require_relative 'explosion'

module Game
  class Space < Gosu::Window
    attr_reader :score
    WIDTH = 960
    HEIGHT = 720
    PLAYER_WIDTH = 480
    PLAYER_HEIGHT = 360
    BOMB_FREQUENCY = 0.03
    def initialize
      super(WIDTH, HEIGHT)
      self.caption = "Space Game"
      @background_image = Gosu::Image.new("assets/sky.jpg", :tileable => true)
      @player = Player.new(self)
      @player.size(PLAYER_WIDTH, PLAYER_HEIGHT)
      @bullets = []
      @bombs = []
      @explosions = []
      @score = 0
      @beep = Gosu::Sample.new "assets/shoot.ogg"
      @font = Gosu::Font.new(20)
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
      @bombs.each(&:draw)
      @explosions.each(&:draw)
      @background_image.draw(0,0,0)
      @font.draw("Score: #{score}", 10, 10, 3, 1.0, 1.0, Gosu::Color::YELLOW)
    end

    def update
      @player.turn_left if button_down?(Gosu::KB_A)
      @player.turn_right if button_down?(Gosu::KB_D)
      @player.accelerate if button_down?(Gosu::KB_W)
      @player.move
      if rand < BOMB_FREQUENCY
        @bombs.push(Bomb.new(self))
      end
      @bombs.each(&:move)
      @bullets.each(&:move)
      @bombs.each do |bomb|
        @bullets.each do |bullet|
          distance = Gosu.distance(bomb.x, bomb.y, bullet.x, bullet.y)
          if distance < bomb.radius + bullet.radius
            @explosions << Explosion.new(self, bomb.x, bomb.y)
            @bombs.delete bomb
            @bullets.delete bullet
            @score += 10
          end
        end
      end
      @explosions.each do |explosion|
        @explosions.delete explosion if explosion.finished
      end
      @bombs.each do |bomb|
        @bombs.delete bomb if bomb.y > HEIGHT + bomb.radius
      end
      @bullets.each do |bullet|
        @bullets.delete bullet unless bullet.onscreen?
      end
    end
  end
end

Game::Space.new.show
