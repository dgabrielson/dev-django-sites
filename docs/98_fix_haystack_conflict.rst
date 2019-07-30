
NB: This seems to only happen in dev and not in production.



Error::
    pkg_resources.ContextualVersionConflict: (Django 1.11.4 (/Users/gabriels/virtualenvs/dev-stats/lib/python3.6/site-packages), Requirement.parse('Django<1.11'), {'django-haystack'})
    
    
Fix (assuming you are already running in the venv)::

    cdvirtualenv bin ; ln -snf $(grep ^__file__ manage.py | cut -f 2 -d \')