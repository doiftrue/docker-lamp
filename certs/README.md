Required packeges
-----------------

`openssl` packege must be installed for this script works. Instalation example for ubuntu:

	sudo apt update
	sudo apt install openssl -y
	openssl version


Usage
-----

1. Place file `create-self-signed-cert.sh` to any directory on your computer and run it. 
	```
	bash ~/path/to/create-self-signed-cert.sh
    ```
2. Enter your local site domain name (ex. mysite.loc).
3. Done! The self-signed certificate created for your site.

Now You need to add the ROOT CA certificate to the global trust certificates repository of your system (ubuntu), browser, etc. (see bellow how to do that).
Then, use a site related cert files: `.key`, `.crt` in yout Apache or Nginx configs.


### About ROOT-CA-certificate

For the script first run (once) the ROOT-CA-certificate is created to the `ROOT_CA_CERT` folder.

Any further created certificates for separete site are signed with that ROOT CA certificate (myRootCA.pem).

Adding the ROOT CA (myRootCA.pem) to the trust store is required to all further generated certificates works correctly.


#### Adding ROOT-CA to Ubuntu

Copy your certificate in `.pem` format (the format that has ----BEGIN CERTIFICATE---- in it) into `/usr/local/share/ca-certificates` and name it with a `.crt` file extension. Then run `sudo update-ca-certificates`.

	$ sudo apt-get install -y ca-certificates
	$ sudo cp ./ROOT_CA_CERT/myRootCA.pem /usr/local/share/ca-certificates/myRootCA.pem.crt
	$ sudo update-ca-certificates

OR using interactive variant (not recomended):

	$ sudo cp ./ROOT_CA_CERT/myRootCA.pem /usr/share/ca-certificates/myRootCA.pem.crt
	$ sudo dpkg-reconfigure ca-certificates

- See: https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/
- See: https://askubuntu.com/questions/73287/how-do-i-install-a-root-certificate
- See: https://support.kerioconnect.gfi.com/hc/en-us/articles/360015200119-Adding-Trusted-Root-Certificates-to-the-Server


#### Adding ROOT-CA to Google Chrome

1. Goto `chrome://settings/certificates` - place this string into the main Google Chrome search field. Or go to `Settings > Privacy and security > Security > Manage sertificates`.
2. Now you need to go to `Authorities` tab and import the ROOT CA Certificate (myRootCA.crt) to the repository.
3. Done! Now any cert you create for any site will work in Google Chrome, because it signed with ROOT-CA that is in trusted repository.

See also: https://support.securly.com/hc/en-us/articles/206081828-How-do-I-manually-install-the-Securly-SSL-certificate-in-Chrome-


#### Adding ROOT-CA to Firefox

1. Goto `about:preferences#privacy` - place this string into the main Firefox search field. Or go to `Settings > Privacy and security`.
2. Scroll down to `Security` section click `View Certificates` button and select `Authorities` tab in the appeared popup window.
3. Import the ROOT CA Certificate (myRootCA.crt) to the repository.
4. Done! Now any cert you create for any site will work in Firefox.

See also: https://docs.vmware.com/en/VMware-Adapter-for-SAP-Landscape-Management/2.1.0/Installation-and-Administration-Guide-for-VLA-Administrators/GUID-0CED691F-79D3-43A4-B90D-CD97650C13A0.html



### Notes

- As an alternative for all this staff you can use `mkcert` lib: https://github.com/FiloSottile/mkcert

- If you can't add cert to the trust repo ensure that file has 644 chmod:
	```
	sudo chmod 644 /usr/local/share/ca-certificates/myRootCA.crt
    ```

- `update-ca-certificates` manual: http://manpages.ubuntu.com/manpages/trusty/man8/update-ca-certificates.8.html

- FILES:
    ```
    /etc/ca-certificates.conf          - A configuration file.
    /etc/ssl/certs/ca-certificates.crt - A single-file of CA certificates. Holds all CA certificates activated in /etc/ca-certificates.conf.
    /usr/share/ca-certificates         - Directory of CA certificates.
    /usr/local/share/ca-certificates   - Directory of local CA certificates (with .crt extension).
    ```

Fresh updates. Remove symlinks in `/etc/ssl/certs` directory.

	sudo update-ca-certificates --fresh

View single certificate data:

	openssl x509 -in certificate.crt -text
