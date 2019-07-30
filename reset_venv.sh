#!/bin/bash
set -e

if [ -n "${VIRTUAL_ENV}" ]; then
    echo "Detected a running virtual environment. This is unsafe."
    echo "Deactivate and try again."
    exit 2
fi

# as long as this script is not symlinked::
# source: https://stackoverflow.com/a/246128
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# check for parameter
if [ -z "$1" ]; then
    echo "You need to specify a virtual environment to reset:"
    for f in $(find "${DIR}" -name reqs.txt -print); do
        subpath=$( echo ${f#${DIR}} | cut -f 2 -d /)
        echo ${subpath}
    done
    exit 1
fi


# check parameter validity
VENV=""
while IFS= read -r -d $'\0' f; do
    subpath=$( echo ${f#${DIR}} | cut -f 2 -d /)
    if [ "${subpath}" == "$1" ]; then
        VENV="$subpath"
        break
    fi
done < <(find "${DIR}" -name reqs.txt -print0)

if [ -z "${VENV}" ]; then
    echo "Not a valid virtual environment for reset."
    exit 1
fi
echo "venv: ${VENV}"


if [ -z "${VIRTUALENVWRAPPER_HOOK_DIR}" ]; then
    VIRTUALENVWRAPPER_HOOK_DIR="${HOME}/.virtualenvs"
fi

VENV_PATH="${VIRTUALENVWRAPPER_HOOK_DIR}/${VENV}"
echo "venv_path: ${VENV_PATH}"

if [ -d "${VENV_PATH}" ]; then
    read -p '-> Virtual environment already exists; are you sure you want to delete? [y/N] ' -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        rm -rf "${VENV_PATH}"
        echo "remove_old: complete"
    else
        echo "Refusing to continue."
    fi
fi

DEV_PATH="${DIR}/${VENV}"
python3 -m venv "${VENV_PATH}"
echo "created: true"
source "${VENV_PATH}/bin/activate"
echo "activated: true"
pip install -U pip setuptools
echo "build_tools: updated"
pip install -r "${DEV_PATH}/reqs.txt"
echo "requirements: installed"
if [[ -f "${DEV_PATH}/django-settings.json" ]]; then
	ln -snf "${DEV_PATH}/django-settings.json" "${HOME}/${VENV}-settings.json"
    echo "json_settings: linked"
fi
if [[ -f "${DEV_PATH}/django-settings.env" ]]; then
	ln -snf "${DEV_PATH}/django-settings.env" "${HOME}/${VENV}-settings.env"
    echo "env_settings: linked"
fi
pushd "${VENV_PATH}/bin"
ln -snf "$(grep ^__file__ manage.py | cut -f 2 -d \')"
echo "manage_script: fixed"
popd

if [[ -f "${DEV_PATH}/copy_live.sh" ]]; then
    read -p '-> Do you want to copy live also? [y/N] ' -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        bash "${DEV_PATH}/copy_live.sh"
        echo "copy_live: finished"
    fi
fi

echo "DONE: complete"
