This Django site is for testing / developing LDAP
integration tools.  As such, it requires an ldap
docker instance to work against.

docker volume create ldap_db
docker volume create ldap_cfg
docker build -t ldap-test -f openldap.dockerfile .
docker run --name test-ldap -d -p 389:389 --restart=always \
   --mount type=volume,src=ldap_db,dst=/var/lib/ldap \
   --mount type=volume,src=ldap_cfg,dst=/etc/ldap/slapd.d \
   ldap-test --loglevel debug

TODO:
* Better enable/disable of samba extensions.
