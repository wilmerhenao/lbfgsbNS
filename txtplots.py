import numpy as np
import matplotlib.pyplot as plt

with open("rosenbrock.csv") as f:
    data = f.read()

data = data.split('\n')

'x = [row.split(' ')[0]] for row in data
'y = [row.split(' ')[1]] for row in data

data = numpy.genfromtxt('rosenbrock.csv', delimiter = ',')

mydata = []
for row in data:
    mydata.append(row.strip().split(','))

fig = plt.figure()

ax1 = fig.add_subplot(111)


ax1.set_title("p vs m")    
ax1.set_xlabel('m')
ax1.set_ylabel('p')

ax1.plot(x,y, c='r', label='the data')

leg = ax1.legend()

plt.show()
