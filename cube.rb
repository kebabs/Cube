require 'pi_piper'
include PiPiper

class Cube

  attr_reader :pins, :destroy, :layers, :drawVoxel, :testAnimation, :loop

  def initialize(dataPin, clockPin, latchPin)

    #@pins = {}

    @currentClock = 0

    @pins = {
      dataPin: dataPin,
      clockPin: clockPin,
      latchPin: latchPin
    }

    @pins.each do |pin, pinNumber|
      @pins[pin] = PiPiper::Pin.new(pin: pinNumber, direction: :out)
    end

    ObjectSpace.define_finalizer(self, proc {
      destroy
    })

    # Create the layers
    @layers = Hash.new
    4.times do |count|
      @layers[count] = 0
    end

    # @layers[0] = 2 ** 16 - 1
    # @layers[1] = 63903
    # @layers[2] = 63903
    # @layers[3] = 2 ** 16 - 1

    # @layers[0] = 32000
    # @layers[1] = 96
    # @layers[2] = 96
    # @layers[3] = 96

    @layers = @layers.values

    @voxelsOn = {
      0 => {},
      1 => {},
      2 => {},
      3 => {}
    }

    loop

    #destroy
  end

  def drawVoxel(x, y, z, save = false)
    if (y == 1)
      x -= 1
      send = 2 ** x
    elsif (y == 2)
      send = (2 ** x) * ((2 ** y) * y)
    elsif (y == 3)
      send = (((2 ** x) * (2 ** y)) ** 2) / (2 ** (x - 1))
    elsif (y == 4)
      send = (((2 ** x) * (2 ** y)) ** 2) / (2 ** (x - 1)) * 4
    end

    sendToLayer(z - 1, send, save)
  end

  def testAnimation
    4.times do |z|
      # sleep(0.5)
      4.times do |y|
        # sleep(0.05)
        4.times do |x|

          drawVoxel(x + 1, y + 1, z + 1)
          drawVoxel(4 - x, 4 - y, 4 - z)
          sleep(0.1)
          # sleep(0.25)
        end

      end

      @layers[z] = 0
      @layers[4 - (z + 1)] = 0
    end
  end

  def testAnimation2
    4.times do |z|
      @layers[z] = 0

        4.times do |x|
          drawVoxel(x + 1, @currentClock + 1, z + 1, true)
        end
      sleep(0.0001)
    end

    # testAnimation3
  end

  def testAnimation3
    4.times do |z|
      @layers[z] = 0

        4.times do |x|
          drawVoxel(x + 1, 4 - @currentClock, z + 1, true)
        end
      sleep(0.0001)
    end

    # testAnimation2
  end

  def marry
    drawVoxel(1, 1, 4, true)
    drawVoxel(1, 1, 3, true)
    drawVoxel(1, 1, 2, true)

    drawVoxel(2, 1, 3, true)
    drawVoxel(2, 1, 2, true)
    drawVoxel(2, 1, 1, true)

    drawVoxel(3, 1, 3, true)
    drawVoxel(3, 1, 2, true)
    drawVoxel(3, 1, 1, true)

    drawVoxel(4, 1, 4, true)
    drawVoxel(4, 1, 3, true)
    drawVoxel(4, 1, 2, true)

    sleep 1
    4.times do |count|
      @layers[count] = 0
    end
    sleep 0.5

    4.times do |count|
      drawVoxel(count + 1, 1, 1, true)
    end

    drawVoxel(2, 1, 2, true)
    drawVoxel(2, 1, 3, true)
    drawVoxel(3, 1, 2, true)
    drawVoxel(3, 1, 3, true)

    4.times do |count|
      drawVoxel(count + 1, 1, 4, true)
    end

    sleep 1
    4.times do |count|
      @layers[count] = 0
    end
    sleep 0.5

    4.times do |count|
      drawVoxel(1, 1, count + 1, true)
      drawVoxel(2, 1, count + 1, true)
    end

    @layers[0] = 15

    sleep 1
    4.times do |count|
      @layers[count] = 0
    end
    sleep 0.5

    4.times do |count|
      drawVoxel(1, 1, count + 1, true)
      drawVoxel(2, 1, count + 1, true)
    end

    @layers[0] = 15

    sleep 1
    4.times do |count|
      @layers[count] = 0
    end
    sleep 0.5

    drawVoxel(1, 1, 4, true)
    drawVoxel(4, 1, 4, true)
    drawVoxel(1, 1, 3, true)
    drawVoxel(4, 1, 3, true)

    3.times do |count|
      drawVoxel(2, 1, count + 1, true)
      drawVoxel(3, 1, count + 1, true)
    end

    sleep 1
    4.times do |count|
      @layers[count] = 0
    end
    sleep 0.5

    2.times do |count|
      drawVoxel(count + 2, 1, 1, true)
      drawVoxel(count + 2, 1, 4, true)
    end

    2.times do |count|
      drawVoxel(1, 1, count + 2, true)
    end

    2.times do |count|
      drawVoxel(4, 1, count + 2, true)
    end

    sleep 1
    4.times do |count|
      @layers[count] = 0
    end
    sleep 0.5

    3.times do |count|
      drawVoxel(1, 1, count + 2, true)
      drawVoxel(4, 1, count + 2, true)
    end

    2.times do |count|
      drawVoxel(count + 2, 1, 1, true)
    end

    sleep 1
    4.times do |count|
      @layers[count] = 0
    end
    sleep 0.5

    3.times do |count|
      drawVoxel(1, 1, count + 1, true)
      drawVoxel(2, 1, count + 1, true)
      drawVoxel(3, 1, count + 1, true)
      drawVoxel(4, 1, count + 1, true)
    end

    drawVoxel(1, 1, 4, true)
    drawVoxel(4, 1, 4, true)

    sleep 1
    4.times do |count|
      @layers[count] = 0
    end
    sleep 0.5

    @layers[0] = 9
    @layers[1] = 15
    @layers[2] = 9
    @layers[3] = 6

    sleep 1
    4.times do |count|
      @layers[count] = 0
    end
    sleep 0.5

    @layers[0] = 11
    @layers[1] = 15
    @layers[2] = 9
    @layers[3] = 7

    sleep 1
    4.times do |count|
      @layers[count] = 0
    end
    sleep 0.5

    @layers[0] = 11
    @layers[1] = 15
    @layers[2] = 9
    @layers[3] = 7

    sleep 1
    4.times do |count|
      @layers[count] = 0
    end
    sleep 0.5

    @layers[0] = 6
    @layers[1] = 6
    @layers[2] = 15
    @layers[3] = 9

    sleep 1
    4.times do |count|
      @layers[count] = 0
    end
    sleep 0.5

    @layers[0] = 15
    @layers[1] = 15
    @layers[2] = 15
    @layers[3] = 9

    sleep 1
    4.times do |count|
      @layers[count] = 0
    end
    sleep 0.5

    @layers[0] = 15
    @layers[1] = 3
    @layers[2] = 1
    @layers[3] = 15

    sleep 1
    4.times do |count|
      @layers[count] = 0
    end
    sleep 0.5

    @layers[0] = 1
    @layers[1] = 14
    @layers[2] = 8
    @layers[3] = 14
  end

  private

  def sendToLayer(z, number, save)
    return @layers[z] = number if !save
    @layers[z] += number
  end

  def destroy
    # Need to come up with a better way to release pins, perhaps extend PiPiper::Pin?
    @pins.each do |key, pinObject|
      `echo #{pinObject.pin} > /sys/class/gpio/unexport`
    end
  end

  def loop
    #puts @currentLayer

    # Clocker
    Thread.new do
      while (true)
        @currentClock += 1
        @currentClock = 0 if @currentClock >= 4
        sleep(0.125)
      end
    end

    Thread.new do
      while(true)

        #sleep(0.001)

        @layers.count.times do |count|

          #@pins[:latchPin].off

          @pins[:latchPin].off

          @currentLayer       = @layers[count].to_s(2).split('')
          @currentLayerSelect = (2 ** count).to_s(2).split('')

          currentLayerPadding = 0
          currentLayerPadding = 16 - @currentLayer.to_a.count unless @currentLayer.to_a.count >= 16

          currentLayerPadding.times do
            #sleep(0.0001)
            @currentLayer.unshift('0')

          end

          currentLayerSelectPadding = 0
          currentLayerSelectPadding = 4 - @currentLayerSelect.to_a.count unless @currentLayerSelect.to_a.count >= 4

          currentLayerSelectPadding.times do
            #sleep(0.0001)
            @currentLayerSelect.unshift('0')
          end

          binary = @currentLayer.join.reverse + @currentLayerSelect.join.reverse + ('0' * 4)

          # output =
          #puts (2 ** count).to_s(2)
          #puts binary.reverse!

          binary.reverse.split('').each do |bit|

            if bit == '1'
              @pins[:dataPin].on
            else
              @pins[:dataPin].off
            end

            #sleep(0.0001)
            @pins[:clockPin].on
            #sleep(0.0001)
            @pins[:clockPin].off

          end


          @pins[:latchPin].on

          #sleep(0.0001)
        end
      end
    end

  end

end

@cube = Cube.new(19, 13, 6)

@cube.marry
# while true
#   @cube.testAnimation2
# end
