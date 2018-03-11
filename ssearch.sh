#!/bin/sh

: '
A Student Search script for iitk.
'

echo ""
echo "|''''''''''''''''''''''''''''''''''''''''''|"
echo "|      WELCOME TO STUDENT SEARCH IITK      |"
echo "|__________________________________________|"
echo ""
echo ""
echo "Parameters for Search :"
echo ""
echo "1. Roll No"
echo "2. Name"
echo "3. Programme"
echo "4. Department"
echo "5. IITK Residence"
echo "6. Email Address"
echo "7. Blood Group"
echo "8. Gender"
echo "9. Country"
echo ""
echo ""
echo "The search query should be a space separated list of [id]=[value] pairs."
echo "e.g. [1]=[170195] [2]=[ayush] [3]=[btech] [4]=[computer] [5]=[hall12] [6]=[ayushk] [7]=[a+] [8]=[m] [9]=[india]"

running='y'

while [ $running != 'n' ]
do
	echo ""
	echo "Enter your search query : "
	read query

	roll=`echo $query | grep -oE '\[1\]=\[([^]]*)\]' | sed -E 's/\[1\]=\[(.*)\]/\1/g'`
	name=`echo $query | grep -oE '\[2\]=\[([^]]*)\]' | sed -E 's/\[2\]=\[(.*)\]/\1/g'`
	prog=`echo $query | grep -oE '\[3\]=\[([^]]*)\]' | sed -E 's/\[3\]=\[(.*)\]/\1/g'`
	dept=`echo $query | grep -oE '\[4\]=\[([^]]*)\]' | sed -E 's/\[4\]=\[(.*)\]/\1/g'`
	addr=`echo $query | grep -oE '\[5\]=\[([^]]*)\]' | sed -E 's/\[5\]=\[(.*)\]/\1/g'`
	emai=`echo $query | grep -oE '\[6\]=\[([^]]*)\]' | sed -E 's/\[6\]=\[(.*)\]/\1/g'`
	bgrp=`echo $query | grep -oE '\[7\]=\[([^]]*)\]' | sed -E 's/\[7\]=\[(.*)\]/\1/g'`
	gend=`echo $query | grep -oE '\[8\]=\[([^]]*)\]' | sed -E 's/\[8\]=\[(.*)\]/\1/g'`
	coun=`echo $query | grep -oE '\[9\]=\[([^]]*)\]' | sed -E 's/\[9\]=\[(.*)\]/\1/g'`
	if [[ $roll || $name || $prog || $dept || $addr || $emai || $bgrp || $gend || $coun ]]
	then
		echo ""
		echo "Searching..."
		echo "Your query yielded the following results :"
		echo ""
		sed -n '1,3p' stud_info.txt
		grep -iE "\|.*$roll.*\|.*$name.*\|.*$prog.*\|.*$dept.*\|.*$addr.*\|.*$emai.*\|.*$bgrp.*\|.*$gend.*\|.*$coun.*\|" stud_info.txt
		sed -n '$p' stud_info.txt
		if [ $? != 0 ]
		then
			echo "No matches found!"
			echo ""
		fi
	else
		echo "Please specify at least one parameter and in the correct format!"
	fi
	echo ""
	echo "Want to search again (y/n) ?"
	read running
done