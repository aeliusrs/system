generate a self signed
```bash
#interactive
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes

# non-interactive and 10 years expiration
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname"
```

you can add the cert.pem in a machine to be recognize, and regenerate the cacert:
```bash
cp cert.pem /etc/ssl/certs/<name>.pem
chmod 744 /etc/ssl/certs/<name>.pem
update-ca-certificates
```

you can also mount it in a container to make it recognize:
```bash
docker run --name example \
 -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt
 -v /etc/ssl/certs/mycert.pem:/etc/ssl/certs/mycert.pem
  hello-world
```
