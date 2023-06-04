#!/bin/bash
# ver 1.0

#
# Run this file with specifying domain in first parameter:
#     ./create-cert.sh my-domain.com
# Or simply (the domain will be asked to be entered into console):
#     ./create-cert.sh

# not empty
if [ -n "$1" ];
	then
		DOM="$1"
	else
		echo "Enter domain:"
		read -r DOM
fi

# empty string
if [ -z "$DOM" ]; then
	echo "ERROR: Domain not set"
	exit 0
fi

SUBJ="/C=US/ST=USA/L=USA/O=Local Sites-DEV/OU=Local Sites-DEV"
THIS_FILE_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

### Create ROOT CA (root certificate authority)

CA_DIR="$THIS_FILE_DIR/ROOT_CA_CERT"
CA_NAME="myRootCA"

# skip if root ca already exists
if [ ! -d "$CA_DIR" ]; then
	mkdir "$CA_DIR"
	# Note: skip `-des3` parameter to not add passphrase
	openssl genrsa -out "$CA_DIR/$CA_NAME.key" 2048
	# generate a root certificate
	openssl req -x509 -new -nodes -key "$CA_DIR/$CA_NAME.key" -sha256 -days 7600 -out "$CA_DIR/$CA_NAME.pem" -subj "$SUBJ/CN=LocalCustomRootCA"
	# convert pem to crt (this file may come in handy)
	openssl x509 -inform PEM -outform DER -in "$CA_DIR/$CA_NAME.pem" -out "$CA_DIR/$CA_NAME.crt"

	# set correct rights
	chmod 644 "$CA_DIR/$CA_NAME.crt"
	chmod 644 "$CA_DIR/$CA_NAME.pem"

	# create copy of .pem with .crt format (it is the way to add it to ubuntu trust store with `sudo update-ca-certificates`)
	cp "$CA_DIR/$CA_NAME.pem" "$CA_DIR/$CA_NAME.pem.crt"
fi


### Create the site certificate and sign it with CA certificate

DOM_DIR="$THIS_FILE_DIR/$DOM"

if [ -d "$DOM_DIR" ]
	then rm "$DOM_DIR"/*
	else mkdir "$DOM_DIR"
fi

# create certificate

openssl genrsa -out "$DOM_DIR/$DOM.key" 2048
openssl req -new -key "$DOM_DIR/$DOM.key" -out "$DOM_DIR/careq.csr" -subj "$SUBJ/CN=$DOM"

# sign certificate

{
	#echo 'nsComment="Kama Custom Generated Certificate"'
	echo 'authorityKeyIdentifier=keyid,issuer'
	echo 'basicConstraints=CA:FALSE'
	echo 'keyUsage=digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment'
	echo 'subjectAltName=@alt_names'
	echo '[alt_names]'
	echo "DNS.1=$DOM"
	echo "DNS.2=*.$DOM"
} >> "$DOM_DIR/$DOM.cnf"

openssl x509 -req -in "$DOM_DIR/careq.csr" -out "$DOM_DIR/$DOM.crt" -days 3000 -sha256 -extfile "$DOM_DIR/$DOM.cnf" \
-CA "$CA_DIR/$CA_NAME.pem" -CAkey "$CA_DIR/$CA_NAME.key" -CAcreateserial

# remove artifacts

rm "$DOM_DIR/$DOM.cnf"
rm "$DOM_DIR/careq.csr"
