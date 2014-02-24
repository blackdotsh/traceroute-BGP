#!/bin/bash
# Licensed under GPLv3
# created by "black" on LET
# please give credit if you plan on using this for your own projects
# https://github.com/blackdotsh
# Depends on http://www.team-cymru.org/Services/ip-to-asn.html#whois for ASN -> Whois

if [[ -z "$1" ]]
then
	echo "IP argurement required. Run the program as: $0 IP_Here";
	exit 1;
fi

OIFS=$IFS;
IFS=$'\n';
for line in $( traceroute  -A "$1" )
do
	echo "$line" | grep "AS" -q;
	if [ $? -eq 0 ]
	then
		AS=$( echo $line | grep -E "\[AS.+?\] " -o | tr -d  "[]" | cut -d " " -f1 );
		ASResult=$( whois -h whois.cymru.com " -v $AS" | tail -n 1 | cut -d "|" -f 5 );
		echo "$line" | sed "s/\]/:$ASResult\]/1";
 
	else
		echo "$line";
	fi	

done
IFS=$OIFS;

