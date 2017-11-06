import time
import sys
if len(sys.argv) == 1:
    print(time.time())
else:
    end_time=time.time()
    dur = end_time - float(sys.argv[1])
    print(dur)
exit(0)


