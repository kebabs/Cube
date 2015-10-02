require 'pi_piper'
include PiPiper

# GPIO Pins
@dataPinNum  = 19
@clockPinNum = 13
@latchPinNum = 6

# Timing
@pause = 0.012

@number = 0

def setup

	destroy
	sleep(0.10)

	@dataPin 	= PiPiper::Pin.new(pin: @dataPinNum, 	direction: :out)
	@clockPin = PiPiper::Pin.new(pin: @clockPinNum, direction: :out)
	@latchPin = PiPiper::Pin.new(pin: @latchPinNum, direction: :out)

	clear
	sleep(0.05)

	# Lets generate a string of 16 zero's
	@binary = "0" * 16
	@binary = @binary.split('')

	#drawPixel(1, 1)
	# drawPixel(2, 1)
	# drawPixel(3, 1)
	# drawPixel(4, 1)

	# drawPixel(1, 2)
	#drawPixel(2, 2)
	# drawPixel(3, 2)
	# drawPixel(4, 2)

	# drawPixel(1, 3)
	# drawPixel(2, 3)
	#drawPixel(3, 3)
	# drawPixel(4, 3)

	# drawPixel(1, 4)
	# drawPixel(2, 4)
	# drawPixel(3, 4)
	#drawPixel(4, 4)

	# drawPixel(1, 1)
	# drawPixel(2, 1)
	# drawPixel(3, 1)
	# drawPixel(4, 1)

	# drawPixel(1, 2)
	# drawPixel(4, 2)
	# drawPixel(1, 3)
	# drawPixel(4, 3)

	# drawPixel(1, 4)
	# drawPixel(2, 4)
	# drawPixel(3, 4)
	# drawPixel(4, 4)

end

def destroy

	# Need to come up with a better way to release pins, perhaps extend Pipiper::Pin?
	`echo #{@dataPinNum} > /sys/class/gpio/unexport`
	`echo #{@clockPinNum} > /sys/class/gpio/unexport`
	`echo #{@latchPinNum} > /sys/class/gpio/unexport`
end

def clear
	@latchPin.off

	16.times do
		@dataPin.off
		@clockPin.on
		@clockPin.off
	end

	@latchPin.on
end

def drawPixel(x, y)

	if (y == 1)
		x -= 1
		send 2 ** x
	elsif (y == 2)
		send (2 ** x) * ((2 ** y) * y)
	elsif (y == 3)
		send (((2 ** x) * (2 ** y)) ** 2) / (2 ** (x - 1))
	elsif (y == 4)
		send (((2 ** x) * (2 ** y)) ** 2) / (2 ** (x - 1)) * 4
	end

end

def send (num)
	@number += num
end

def testAnimation(testVar)
	@testRand = !@testRand
	return anim1 unless testVar
	anim2
end

def anim1
	drawPixel(1, 1)
	drawPixel(2, 1)
	drawPixel(3, 1)
	drawPixel(4, 1)

	drawPixel(1, 2)
	drawPixel(4, 2)
	drawPixel(1, 3)
	drawPixel(4, 3)

	drawPixel(1, 4)
	drawPixel(2, 4)
	drawPixel(3, 4)
	drawPixel(4, 4)
end

def anim2
	drawPixel(2, 2)
	drawPixel(3, 2)
	drawPixel(2, 3)
	drawPixel(3, 3)
end

setup

#@number = @number.to_s(2)

@testRand = false

while(true)

	begin

	# rand(1..16).times do
	# 	drawPixel(rand(1..4), rand(1..4))
	# end

	testAnimation(@testRand)


	puts @number

	@latchPin.off

	@binary = @number.to_s(2).split('')

	@times_run = 0

	@times_run = 16 - @binary.to_a.count unless @binary.to_a.count >= 16

	@times_run.times do
		@dataPin.off
		@clockPin.on
		@clockPin.off
	end

	@binary.to_a.each do |x|

		if x == '1'
			@dataPin.on
		else
			@dataPin.off
		end

		@clockPin.on
		@clockPin.off

	end

	@latchPin.on

	sleep(0.3)

	clear
	@number = 0

	#sleep(0.01)

	rescue SystemExit, Interrupt, Exception
		puts "Exiting"

		clear
		destroy

		raise
	end

end
