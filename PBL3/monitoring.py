import serial

usb_device = "/dev/tty.usbserial-A50285BI"

monitor = serial.Serial(usb_device, baudrate=9600)

while True:
	reading = monitor.read()
	print(reading)