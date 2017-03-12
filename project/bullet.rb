require_relative 'movement'
module Game
  class Bullet
    SPEED = 5
    attr_reader :x, :y, :radius

    def initialize(window, x, y, direction)
      @image     = Gosu::Image.new('assets/bl.png')
      @window    = window
      @radius    = 12.8
      @Movement = Movement.new(x,y,direction,SPEED)
    end

    def draw
      @image.draw(@Movement.x - @radius, @Movement.y - @radius, 1)
    end

    def move
      @Movement.move
    end

    def onscreen?
      right = @window.width + @radius
      left = -@radius
      top = -@radius
      bottom = @window.height + @radius
      @Movement.x > left && @Movement.x < right && @Movement.y > top && @Movement.y < bottom
    end
  end
end
