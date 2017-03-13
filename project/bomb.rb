module Game
  class Bomb
    attr_reader :x, :y, :radius
    def initialize(window)
      @radius = [50, 52].max / 2
      @x = rand(window.width - 2 * @radius) + @radius
      @y = 0
      @image = Gosu::Image.new('assets/bomb.png')
      @window = window
      @speed = 4
    end

    def draw
      @image.draw(@x, @y , 1)
    end

    def move
      @y += @speed
    end
  end
end
