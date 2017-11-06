from mpi4py import MPI
import random
import time
import math
import sys
import gc
import numpy


def calculate(num):
    circle = 0
    i = 0
    random.seed(0)
    while i < num:
        x = 2 * random.random() - 1
        y = 2 * random.random() - 1
        if math.pow(x, 2) + math.pow(y, 2) <= 1:
            circle += 1
        if i != 0 and i % 1000000 == 0:
            gc.collect()
        i += 1
    return circle

start_time = time.time()
comm = MPI.COMM_WORLD
rank = comm.Get_rank()
n = int(sys.argv[1])
size = comm.Get_size()

local_n = math.floor(n / size)
if n % size != 0:
    if rank == 1:
        local_n += n % size

piPart = numpy.zeros(1)
recv_buffer = numpy.zeros(1)

piPart[0] = calculate(local_n)
total = 0

if rank == 0:
    total = piPart[0]
    for i in range(1,size):
        comm.Recv(recv_buffer, source=MPI.ANY_SOURCE)
        total += recv_buffer[0]
else:
    comm.Send(piPart,dest=0)

if comm.rank == 0:
    dur=time.time()-start_time
    total = total/n*4
    print "\n\tNUMBER: ", n
    print "\tRESULT: ", total
    print "\tTIME:   ", dur



