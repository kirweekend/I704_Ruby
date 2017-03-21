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
      @image = Gosu::Image.new("assets/heart.png")
      @player = Player.new(self)
      @player.size(PLAYER_WIDTH, PLAYER_HEIGHT)
      @bullets = []
      @bombs = []
      @explosions = []
      @score = 0
      @beep = Gosu::Sample.new "assets/shoot.ogg"
      @boom = Gosu::Sample.new "assets/explosion.ogg"
      @font = Gosu::Font.new(40)
    end

    def button_down(id)
      if id == Gosu::KbSpace
        @bullets.push(Bullet.new(self, @player.x, @player.y, @player.angle))
        @beep.play
      end
    end

    def draw
      if @new_game
        @new_game.draw("Final Score: #{@score}", 315, 320, 4, 1.0, 1.0, Gosu::Color::YELLOW)
        @new_game.draw("Press Return to Try Again", 200, 270, 4, 1.0, 1.0, Gosu::Color::YELLOW)
        @background_image.draw(0,0,0)
        @bullets = []
        @bombs = []
        @explosions = []
      else
        @player.draw()
        @bullets.each(&:draw)
        @bombs.each(&:draw)
        @explosions.each(&:draw)
        @background_image.draw(0,0,0)
        @image.draw(40, 15, 3)
        @font.draw("#{score}", 100, 14, 3, 1.0, 1.0, Gosu::Color::YELLOW)
      end
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
            @boom.play
            @score += 10
          end
        end
      end
      @bombs.each do |bomb|
        distance_p = Gosu.distance(bomb.x, bomb.y, @player.x, @player.y)
        if distance_p < bomb.radius + @player.radius
          @explosions << Explosion.new(self, bomb.x, bomb.y)
          @bombs.delete bomb
          @new_game = Gosu::Font.new(50)
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

      if @new_game and button_down? Gosu::KbReturn
        @new_game = nil
        @score = 0
        @player = Player.new(self)
        @player.size(PLAYER_WIDTH, PLAYER_HEIGHT)
        @bullets = []
        @bombs = []
        @explosions = []
      end
    end
  end
end

Game::Space.new.show
