OPENSSL=	openssl
CNF=		./openssl.cnf
CA=		${OPENSSL} ca -config ${CNF}
REQ=		${OPENSSL} req -config ${CNF}

DIR=            ./ssl
KEY=		ssl/certs/ca.cert.pem
KEYMODE=	RSA

CACERT=		ssl/cacert.pem
CADAYS=		3650

CRL=		crl.pem
INDEX=		ssl/index.txt
SERIAL=		ssl/serial

CSR=            ${DIR}/csr/


CADEPS=		${CNF} ${KEY} ${CACERT}

all:	${CRL}

root:
	mkdir -p ssl/root/ca || :
	mkdir -p ssl/certs || :
	mkdir -m0700 -p ssl/private || :
	touch ssl/private/key.pem || :

setup: root casetup

${CRL}:	${CADEPS}
	${CA} -gencrl -out ${CRL}

${CACERT}: ${CNF} ${KEY}
	@echo "###############################################################"
	@echo "Creating CA Certificate for the first time...."
	@echo "###############################################################"
	${REQ} -key ${KEY} -x509 -new -days ${CADAYS} -out ${CACERT}
	rm -f ${INDEX}
	touch ${INDEX}
	echo 100001 > ${SERIAL}
	mkdir ${DIR}/newcerts

${KEY}: ${CNF}
	@echo "###############################################################"
	@echo "Creating CA Key for the first time...."
	@echo "###############################################################"
	mkdir -m0700 -p $(dir ${KEY})
	touch ${KEY}
	chmod 0600 ${KEY}
	${OPENSSL}  genpkey -algorithm ${KEYMODE} -out ${KEY}

ssl/csr/%.csr:
	@echo "###############################################################"
	@echo "Creating CSR... "
	@echo "###############################################################"
	mkdir -m0700 -p $(dir ${CSR}) | :
	${OPENSSL} req -out ${@} -new -newkey rsa:2048 -nodes -keyout ${@:.csr=_key.pem}

revoke:	${CADEPS} ${item}
	@test -n $${item:?'usage: ${MAKE} revoke item=cert.pem'}
	${CA} -revoke ${item}
	${MAKE} ${CRL}

sign:	${CADEPS} ${item}
	@test -n $${item:?'usage: ${MAKE} sign item=request.csr'}
	mkdir -p newcerts
	${CA} -in ${item} -out ${item:.csr=.crt}

show: ${item}
	${OPENSSL} x509 -noout -text -in ${item}

pem2der: ${item}
	${OPENSSL} x509 -outform der -in ${item} -out ${item:.pem=.der}
