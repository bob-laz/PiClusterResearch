import random
import time
import math
import sys
import gc

def calculate(n):
    circle = 0
   # x = []
   # y = []
    i=0
    while (i<n):
        x = (2*random.random()-1)
        y = (2*random.random()-1)
        if math.pow(x, 2) + math.pow(y, 2) <= 1:
            circle += 1
        if i !=0 and i % 1000000 == 0:
            gc.collect()
        i += 1
    return circle

#call to calculate pi
piApprox = calculate(int(sys.argv[1]))
#printing out results
print(piApprox)
sys.exit(0)




