#!/bin/bash

#getting the starting time
start_time=$(python /home/pi/calcPi/gettime.py)

#dividing up the input value by 8 (number of nodes)
((n = $1 / 8))

# Parallel call to all the nodes to start calculating pi
ans=$(pssh -h hostfile -l pi -i -t 0 "python /home/pi/calcPi/calcPi5.py $n" | grep -v "^\[")

# store the values into an array
read -a arr <<<$ans

#setting the sum value to zero
((x = 0))


# summing the results from the nodes
for element in "${arr[@]}"
do
	((x=$x + $element))
done
# used bc (bash calculate) to calculate the value of pi. 
result=$(bc <<< "scale=14; $x / $1 * 4")

#outputting the results
echo -e "\nResult: $result"


dur=$(python /home/pi/calcPi/gettime.py $start_time)
echo "Time: $dur"


