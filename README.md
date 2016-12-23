# Running a quick CA for testing your product

## Intro

Sometimes, some of your project needs a certificate.  For that you
need to install a certificate server and get a certificate from it. 
This might take a lot of time.

This little project will get you going quickly by utilizing the
openssl ca on Linux platform.  This article is based on Arch linux.
You can let me know if this works on other linux/mac platforms.

You shouldn't be using this for a production deployment.  Use a well
defined certificate authority

## Credits

This is based on the instructions from 
https://wiki.archlinux.org/index.php/OpenSSL

and

https://jamielinux.com/docs/openssl-certificate-authority/create-the-root-pair.html

## Usage

* Pre-requisites: Linux, openssl, make installed

* checkout the project first

```
git clone https://github.com/tsureshkumar/util-own-ca.git
```

* create your instance based files

* get a signed certificate by the temporary created CA

```
make sign item=ssl/csr/cert2.csr
```

This first asks the details to create the CA certificate and key. If
already created, it then only asks the details for the new cert.

Once successfully run, it creates a certificate in ssl/csr/cert.crt


