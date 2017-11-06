#!/bin/bash
start_time=$(python /home/pi/calcPi/gettime.py)
((n = $1 / 8))
ans=$(pssh -h hostfile -l pi -i -t 0 "python /home/pi/calcPi/calcPi.py $n" | grep -v "^\[")

read -a arr <<< $ans

((x = 0))

for element in "${arr[@]}"
do
	((x=$x + $element))
done

result=$(bc <<< "scale=14; $x / $1 * 4")

echo -e "\nResult: $result"
echo -e "Time: $(python /home/pi/calcPi/gettime.py $start_time)\n"


