import serial
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import struct

out = 0
data = [0]
monitor = serial.Serial(port="/dev/tty.usbserial-A50285BI", baudrate=9600)

fig = plt.figure()
axis = fig.add_subplot(1,1,1)

def animate(i):
    r = ord(monitor.read())
    if(r== 10):
        raw = monitor.read(2)
        nums = struct.unpack('>1h', raw)
        #print(nums)
        val = nums[0]
        print(val)
        data.append(val)
        axis.clear()
        axis.plot(data[-50:])


anim = animation.FuncAnimation(fig, animate, interval=1)
plt.show()
