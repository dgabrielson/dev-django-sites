Individual dev sites should supply their own copy_live.sh script
which does the relevant database AND media copy.


Clone live Django DB::

Pure Django.  Use this if Live and Dev use different DB systems… this takes a long time; using database dumps and restores is much faster, but requires the same db engine.
On live server::

	manage.py dumpdata > ~/dbdata.json

SCP this to dev system.  On Dev::

	manage.py migrate # if needed to create
	manage.py sqlflush | manage.py dbshell # to reset
	manage.py loaddata ~/dbdata.json


Pure DB snapshot and restore, and database/role creation, is discussed in the
docker_db docs.
