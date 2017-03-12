module Game
  class Movement
    attr_reader :x, :y, :direction, :speed

    def initialize(x,y,direction,speed)
      @x = x 
      @y = y
      @direction = direction
      @speed = speed
    end

    def move
      @x += Gosu.offset_x(@direction, speed)
      @y += Gosu.offset_y(@direction, speed)
    end
  end
end
