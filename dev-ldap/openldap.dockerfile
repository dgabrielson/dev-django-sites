
FROM osixia/openldap:latest

# https://github.com/osixia/docker-openldap

# VOLUMES:
#   - /var/lib/ldap [persitent data]
#   - /etc/ldap/slapd.d [persitent data]


COPY ldif/* /container/service/slapd/assets/config/bootstrap/ldif/custom/

# These should get put into an env file...
ENV LDAP_DOMAIN="math.umanitoba.ca"
ENV LDAP_ORGANISATION="Department of Mathematics, University of Manitoba"
# mpw: admin#slapd@head.gauss.math.umanitoba.ca
ENV LDAP_ADMIN_PASSWORD="XXXXXXXX"


#ENV LDAP_REMOVE_CONFIG_AFTER_SETUP="false"
