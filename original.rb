require 'pi_piper'
include PiPiper

# GPIO Pins
@dataPinNum  = 19
@clockPinNum = 13
@latchPinNum = 6

# Timing
@pause = 0.012

def setup

	destroy
	sleep(0.10)

	@dataPin 	= PiPiper::Pin.new(pin: @dataPinNum, 	direction: :out)
	@clockPin = PiPiper::Pin.new(pin: @clockPinNum, direction: :out)
	@latchPin = PiPiper::Pin.new(pin: @latchPinNum, direction: :out)

	clear
	sleep(0.05)

	@count = 0

end

def destroy

	# Need to come up with a better way to release pins, perhaps extend Pipiper::Pin?
	`echo #{@dataPinNum} > /sys/class/gpio/unexport`
	`echo #{@clockPinNum} > /sys/class/gpio/unexport`
	`echo #{@latchPinNum} > /sys/class/gpio/unexport`
end

def clear
	@latchPin.on
	@latchPin.off

	16.times do
		#@latchPin.off
		@dataPin.off
		#sleep(0.01)
		@clockPin.on
		#sleep(0.01)
		@clockPin.off
		#sleep(0.01)
		#@latchPin.on
	end

	# 7.times do
	# 	@latchPin.off
	# 	@dataPin.on
	# 	#sleep(0.01)
	# 	@clockPin.on
	# 	#sleep(0.01)
	# 	@clockPin.off
	# 	#sleep(0.01)
	# 	puts "1"
	# 	@latchPin.on
	# end

	@latchPin.on
end

def send

end

setup


while(true)

	begin

	@latchPin.off

	@count += 1

	@binary = @count.to_s(2).split('')

	#puts @count.to_s(2)

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

	#sleep(0.001)

	rescue SystemExit, Interrupt, Exception
		puts "Exiting"

		clear
		destroy

		raise
	end

end
