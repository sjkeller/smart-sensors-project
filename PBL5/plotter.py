import serial
import matplotlib.pyplot as plt
import matplotlib.animation as animation

out = 0
data = []
monitor = serial.Serial(port="/dev/tty.usbserial-A50285BI", baudrate=9600)

fig = plt.figure()
axis = fig.add_subplot(1,1,1)

def animate(i):
    raw = monitor.readline()
    out = int.from_bytes(raw, "little", signed=True)
    print(out)
    data.append(out - 675000)
    axis.clear()
    axis.plot(data[-50:])


anim = animation.FuncAnimation(fig, animate, interval=1)
plt.show()
