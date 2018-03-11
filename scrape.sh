#!/bin/sh

depts=( 'ACES' 'ACMS' 'AE' 'BIO' 'BSBE' 'CDC' 'CDTE' 'CESE' 'CELT' 'CELP' 'CMCH' 'CHE' 'CHM'\
	 'CE' 'CGS' 'CSE' 'COSE' 'BSE' 'MD' 'DESP' 'ES' 'ECOS' 'ECO' 'ECON' 'EE' 'MCH'\
	 'EEM' 'HSS' 'IME' 'LT' 'DES' 'MDES' 'MET' 'MME' 'MSE' 'MS' 'MSP' 'MATH' 'ME' 'MEC'\
	 'VLFM' 'MTH' 'NET' 'PHY' 'STAT' 'SBER' )

touch 'student_info.txt'

for de in ${depts[*]}
do
	counter='0'
	page=`curl "https://oa.cc.iitk.ac.in/Oa/Jsp/OAServices/IITk_SrchStudRoll.jsp?recpos=${counter}&selstudrol=&selstuddep=${de}&selstudnam="`
	maxc=`echo "$page" | grep -iA3 'you are viewing' | sed -nE '$p' | sed -E 's/[^0-9]*([0-9]+).*/\1/'`
	while [ $counter -le $maxc ]
	do
		page=`curl "https://oa.cc.iitk.ac.in/Oa/Jsp/OAServices/IITk_SrchStudRoll.jsp?recpos=${counter}&selstudrol=&selstuddep=${de}&selstudnam="`
		for rollno in `echo "$page" | grep -Eo 'numtxt=(.*)&amp' | sed -E 's/numtxt=(.*)&amp/\1/'`
		do
			studpage=`curl "https://oa.cc.iitk.ac.in/Oa/Jsp/OAServices/IITk_SrchRes.jsp?typ=stud&numtxt=${rollno}&sbm=Y"`
			
			name=`echo "$studpage" | egrep -iA1 '<b>.*Name.*</b>' | sed -n '$p' | egrep -o '[^[:space:]].*[^[:space:]]' | sed -E 's/ +/ /g'`
			prog=`echo "$studpage" | egrep -iA1 '<b>.*Program.*</b>' | sed -n '$p' | egrep -o '[^[:space:]].*[^[:space:]]' | sed -E 's/ +/ /g'`
			dept=`echo "$studpage" | egrep -iA1 '<b>.*Department.*</b>' | sed -n '$p' | egrep -o '[^[:space:]].*[^[:space:]]' | sed -E 's/ +/ /g'`
			host=`echo "$studpage" | egrep -iA1 '<b>.*Hostel Info.*</b>' | sed -n '$p' | egrep -o '[^[:space:]].*[^[:space:]]' | sed -E 's/ +/ /g'`
			emai=`echo "$studpage" | grep -ioE 'mailto:(.*)\">' | sed -E 's/mailto:(.*)\">/\1/g'`
			bgrp=`echo "$studpage" | egrep -iA1 '<b>.*Blood Group.*</b>' | sed -n '$p' | egrep -o '[^[:space:]].*[^[:space:]]' | sed -E 's/ +/ /g'`
			cate=`echo "$studpage" | sed -nE 's/.*<b>.*Category.*<\/b>(.*)<br>.*/\1/p'`
			gend=`echo "$studpage" | egrep -iA1 '<b>.*Gender.*</b>' | sed -n '$p' | egrep -o '[^[:space:]].'`
			coun=`echo "$studpage" | egrep -iA1 '<b>.*Country.*</b>' | sed -n '$p' | egrep -o '[^[:space:]].*[^[:space:]]' | sed -E 's/ +/ /g'`
			padd=`echo "$studpage" | egrep -iA1 '<b>.*Permanent.*</b>' | sed -n '1p' | sed -E 's/.*<br>(.*)<br>.*/\1/'`
			#phno=`echo "$studpage" | egrep -iA1 '<b>.*Permanent.*</b>' | sed -n '$p' | sed -E 's/[^0-9]*([0-9]+)[^0-9]*([0-9]+)[^0-9]*/\1/'`
			#mono=`echo "$studpage" | egrep -iA1 '<b>.*Permanent.*</b>' | sed -n '$p' | sed -E 's/[^0-9]*([0-9]+)[^0-9]*([0-9]+)[^0-9]*/\2/'`
			phno=`echo "$studpage" | egrep -iA1 '<b>.*Permanent.*</b>' | sed -n '$p' | sed -E 's/.*Phone no:(.*)<br>Mobile no:(.*)<.*>.*/\1/'`
			mono=`echo "$studpage" | egrep -iA1 '<b>.*Permanent.*</b>' | sed -n '$p' | sed -E 's/.*Phone no:(.*)<br>Mobile no:(.*)<.*>.*/\2/'`

			echo $rollno $name $prog $dept $host $emai $bgrp $cate $gend $coun $padd $phno $mono >> student_info.txt
		done
		counter=`expr $counter + 12`
	done
done
