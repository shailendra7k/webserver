#!/bin/bash
read -p 'press y:' confirm
echo $confirm
if [[ "$confirm" = "y" ]];
then
	echo "yes"
else
	echo "not"
fi
