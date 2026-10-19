require "gosu"

class Game < Gosu::Window
  def initialize
    super(640,480)
    self.caption = "Lamans Morötter"
    @i = 0

    @carrot = Gosu::Image.new("media/img/carrot.png")
    @munch = Gosu::Sample.new("media/audio/omnomnom.mp3")
    @llama = Gosu::Image.new("media/img/llama.png")
    
    @x = 270
    @y = 180
    @target = 1

    @carrot_y_moveset = Gosu.random(-2,2)
    @carrot_x_moveset = Gosu.random(-2,2)
    @carrot_x = Gosu.random(0, width - @carrot.width)
    @carrot_y = Gosu.random(0, height - @carrot.height)

    @font = Gosu::Font.new(24)
    @score = 0
  end

  def draw
    @carrot.draw(@carrot_x, @carrot_y, 0)
    @llama.draw(@x,@y,0,center_x=@target)
    #@llama.draw_rot(@x+@llama.width/2, @y+@llama.height/2, 0, center_x=@target)
    @font.draw_text("Morötter: #{@score}", 10, 10, 10)
  end

  def update
    @x += 5 if Gosu.button_down?(Gosu::KB_D)
    @x -= 5 if Gosu.button_down?(Gosu::KB_A)
    @y += 5 if Gosu.button_down?(Gosu::KB_S)
    @y -= 5 if Gosu.button_down?(Gosu::KB_W)

    @x = @x.clamp(0, width - @llama.width)
    @y = @y.clamp(0, height - @llama.height)
    @carrot_x = @carrot_x.clamp(0, width - @carrot.width)
    @carrot_y = @carrot_y.clamp(0, height - @carrot.height)
    
    @target = -1 if Gosu.button_down?(Gosu::KB_A)
    @target = 1 if Gosu.button_down?(Gosu::KB_D)

    @carrot_x = @carrot_x.-(@carrot_x_moveset)
    @carrot_y = @carrot_y.-(@carrot_y_moveset)

    if Gosu.distance(@x, @y, @carrot_x, @carrot_y) < 80
      @munch.play
      @score += 1
      @carrot_x = Gosu.random(0, width - @carrot.width)
      @carrot_y = Gosu.random(0, height - @carrot.height)
      @carrot_x_moveset += @x.to_f/10
      @carrot_y_moveset += @y.to_f/10
      @i = 1.2
    end
    @i += 1/60.to_f
    print @i
    if @i >= 1.25
      @carrot_x_moveset = Gosu.random(-2,2)
      @carrot_y_moveset = Gosu.random(-2,2)
      @i = 0
    end
  end
end

Game.new.show