This Django site is for testing / developing the skaro
HPC platform.  As such, it requires additional docker
instances to work against.
- ldap (see ../dev-ldap/)
- skaro controller and compute nodes:

Use the ../dev-ldap/openldap.dockerfile to create a "math-ldap" container.

Use the Makefile in this folder to create the relevant skaro containers.

TODO: replace --link with container networks.
(need new container instances of images "ldap-test" and "django-devdb")

docker network create skaronet
....


TODO: compute node LDAP for user context of running jobs.


NOTE: This mirrors the ~/.virtualenvs/dev-skaro/src/ packages
into ./src/ so that they can be copied into the base docker image.
This is done so that you don't need to have committed changes
in the local dev repo in order to test with docker.
