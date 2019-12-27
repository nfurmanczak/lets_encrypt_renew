#!/bin/bash

# Default location for lets encrypt TLS certs, please change if you use 
# a different dir
tlscerts='/etc/letsencrypt/live/*/cert.pem'

# Check if necessary tools are installed
which date &> /dev/null
if [ $? -eq 1 ]; then
	printf "Command date not found. Please install the date tool\nExit."
	exit 1
fi

which openssl &> /dev/null
if [ $? -eq 1 ]; then
	printf "Command openssl not found. Please install the openssl tool\nExit."
	exit 1
fi

# current date in iso 8601 format 
curdate=`date --iso-8601`


for file in $tlscerts; do
	fqdn=`openssl x509 -noout -subject -in $file | cut -d' ' -f 3`
	enddate=`date --date="$(openssl x509 -in $file -noout -enddate | cut -d= -f 2)" --iso-8601`
	diff=$(($(date -d "$enddate" '+%s') - $(date -d "$curdate" '+%s')))
	diffDays=$(($diff/(3600*24)))

	if [ $diffDays -lt 10 ]; then
		/opt/letsencrypt/certbot-auto	renew --cert-name $fqdn &> /dev/null 
	fi
done
