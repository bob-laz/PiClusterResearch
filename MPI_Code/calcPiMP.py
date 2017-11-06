import multiprocessing
import random
import time
import math
import sys
import gc

#function that runs in parallel on each node
def calculate(n, send_end):
    circle = 0
    i = 0
    #random.seed(0)
    while i < n:
        x = (2 * random.random() - 1)
        y = (2 * random.random() - 1)
        if math.pow(x, 2) + math.pow(y, 2) <= 1:
            circle += 1
        if i != 0 and i % 1000000 == 0:
            gc.collect()
        i = i + 1
    send_end.send(circle)

#main
if __name__ == '__main__':
    #arguments being passed in to the node
    arg1 = int(sys.argv[1])
    #dividing the argument by 4 inorder to run in parallel
    n=arg1/4
    #job array
    jobs = []
    #result array
    pipe_list = []
    #creating and starting all the processes
    for i in range(4):
        recv_end, send_end = multiprocessing.Pipe(False)
        p = multiprocessing.Process(target=calculate, args=(n, send_end))
        jobs.append(p)
        pipe_list.append(recv_end)
        p.start()
    
    #waiting for the results to finish and collecting the results
    for proc in jobs:
        proc.join()

    #appending the list of results
    result_list = [x.recv() for x in pipe_list]

    #summing the results
    result = 0
    for x in result_list:
        result = result + int(x)
   
    # returning the results
    print(result)
    exit(0)
	
	
