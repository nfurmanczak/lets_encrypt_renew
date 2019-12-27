#!/bin/bash

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

curdate=`date --iso-8601`

for file in /etc/letsencrypt/live/*/cert.pem; do
	fqdn=`openssl x509 -noout -subject -in $file | cut -d' ' -f 3`
	enddate=`date --date="$(openssl x509 -in $file -noout -enddate | cut -d= -f 2)" --iso-8601`
	diff=$(($(date -d "$enddate" '+%s') - $(date -d "$curdate" '+%s')))
	diffDays=$(($diff/(3600*24)))

	if [ $diffDays -lt 80 ]; then
		/opt/letsencrypt/certbot-auto	renew --cert-name $fqdn --dry-run
	fi
done
