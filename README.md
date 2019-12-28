## lets_encrypt_renew

This tiny BASH script can help your to update all lets encrypt TLS certificates for apache or nginx via a cronjob. The script requires the command line tools date, openssl and of course lets encrypt to be executed. There are several methods to update a lets encrypt certificate. It is also possible to update all certificates automatically. 

The script uses a loop to search for certificates in the directory /etc/letsencrypt/live/\*/cert.pem. The CN (FQDN) and the expiration date (ENDDATE) are read from each certificate with openssl. When a certificate expires in 10 days (or less), it will be  automatically renewed with the certbot.

If you save the certificates in a different directory, you may have to change this directory in the script. Additional the path to the tool certbot-auto must be correct.

Useful commands for the certbot-auto tool: 
- certbot-auto renew --cert-name domain.com (renew only one specific cert)
- certbot-auto renew (renew all )
