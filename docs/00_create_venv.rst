Setup virtualenv::

    python3 -m venv <path to location>

e.g.,::

    VENV="dev-stats"
    python3 -m venv ~/.virtualenvs/${VENV}
    workon ${VENV} # or source ~/.virtualenvs/${VENV}/bin/activate
    pip install -r ~/src/dev-django-sites/${VENV}/reqs.txt
    ln -snf ~/src/dev-django-sites/${VENV}/django-settings.json ~/${VENV}-settings.json
    # optionally::
    bash ~/src/dev-django-sites/${VENV}/copy_live.sh   

Right now; you also need::

    cdvirtualenv bin ; ln -snf $(grep ^__file__ manage.py | cut -f 2 -d \')
