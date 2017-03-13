module Game
  class Bullet
    SPEED = 12
    attr_reader :x, :y, :radius

    def initialize(window, x, y, angle)
      @x         = x
      @y         = y
      @direction = angle
      @image     = Gosu::Image.new('assets/bl.png')
      @window     = window
      @radius = [30, 30].max / 2

      @x += Gosu.offset_x(@direction, SPEED * 5)
      @y += Gosu.offset_y(@direction, SPEED * 5)
    end

    def draw
      @image.draw(@x - @radius, @y - @radius, 1)
    end

    def move
      @x += Gosu.offset_x(@direction, SPEED)
      @y += Gosu.offset_y(@direction, SPEED)
    end

    def onscreen?
      right = @window.width + @radius
      left = -@radius
      top = -@radius
      bottom = @window.height + @radius
      @x > left && @x < right && @y > top && y < bottom
    end
  end
end
