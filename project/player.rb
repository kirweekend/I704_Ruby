module Game
  class Player
    attr_reader :x, :y, :radius, :angle
    ROTATION = 5
    ACCELERATION = 1
    FRICTION = 0.9

    def initialize(window)
      @image = Gosu::Image.new("assets/rock.png")
      @x = @y = @vel_x = @vel_y = @angle = 0.0
      @score = 0
      @radius = 50
      @window = window
    end

    def size(x, y)
      @x, @y = x, y
    end

    def turn_right
      @angle += ROTATION
    end

    def turn_left
      @angle -= ROTATION
    end

    def accelerate
      @vel_x += Gosu.offset_x(@angle, ACCELERATION)
      @vel_y += Gosu.offset_y(@angle, ACCELERATION)
    end

    def move
      @x += @vel_x
      @y += @vel_y
      @vel_x *= FRICTION
      @vel_y *= FRICTION

      if @x > @window.width - @radius
        @vel_x = 0
        @x = @window.width - @radius
      end

      if @x < @radius
        @vel_x = 0
        @x = @radius
      end

      if @y > @window.height - @radius
        @vel_y = 0
        @y = @window.height - @radius
      end

      if @y < @radius
        @vel_y = 0
        @y = @radius
      end
    end

    def draw
      @image.draw_rot(@x, @y, 1, @angle)
    end
  end
end
