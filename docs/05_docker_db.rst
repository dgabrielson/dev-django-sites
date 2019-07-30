BUILDING and running the Docker Database Image::

    # run in the project folder
    docker volume create pgdata ## persist data even across image rebuilds
    docker build -t django-devdb -f Dockerfile.db .
    docker run -d --name devdb -p 5432:5432 --restart=always --mount source=pgdata,destination=/var/lib/postgresql/data django-devdb

Backup / Restore all databases (if needed)::

    docker exec devdb pg_dumpall -U postgres -v > backup.sql
    cat backup.sql | docker exec -i devdb psql -U postgres -e

Backup / Restore single database::

    docker exec devdb pg_dump -U postgres --format=c dbname > dbname.sqlc
    cat ~/dbname.sqlc | docker exec -i devdb pg_restore -U postgres -d postgres

Setup a new role and database::

	docker exec -it devdb psql -U postgres
	   CREATE ROLE foouser WITH LOGIN ENCRYPTED PASSWORD 'barPassword';
	   CREATE DATABASE foobar WITH OWNER foouser;
	   ALTER USER foouser CREATEDB;	# optional: for test db
    # OR
    cat {common,dev-site}/dev-dbinit.sql | docker exec -i devdb psql -U postgres


Setup *all* roles and databases (e.g., after [re]initializing the docker container data)::

    cat */dev-dbinit.sql | docker exec -i devdb psql -U postgres

On macOS, use screen to access the docker VM console (advanced)::

    screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty
