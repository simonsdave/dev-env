#!/usr/bin/env bash

set -e

confirm_ok() {
    while true
    do
        read -p "${1:-} (y/n)> " -n 1 -r
        if [ "$REPLY" != "" ]; then
            echo
        fi

        case "${REPLY:-}" in
            [yY])
                break
                ;;
            [nN])
                return 1
                ;;
            *)
                ;;
        esac
    done

    return 0
}

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

#
# increment the project's version number
#

REPO_ROOT_DIR=$(git rev-parse --show-toplevel)
REPO=$(basename "$REPO_ROOT_DIR")
INIT_DOT_PY=$REPO_ROOT_DIR/${REPO//-/_}/__init__.py
CURRENT_VERSION=$(grep __version__ "$INIT_DOT_PY" | sed -e "s|^.*=\\s*['\"]||g" | sed -e "s|['\"].*$||g")

# install is necessary evil to make things super simple ...
pip install semantic-version > /dev/null

NEXT_VERSION=$(python -c "import semantic_version; print semantic_version.Version('$CURRENT_VERSION').next_minor()")
if ! confirm_ok "Next version will be '$NEXT_VERSION'. That ok?"; then
    while true
    do
        read -r -p "Next version number? ($NEXT_VERSION) > "

        if [ "$REPLY" == "" ]; then
            break
        fi

        if python -c "import semantic_version; import sys; sys.exit(0 if semantic_version.validate('$REPLY') else 1)"; then
            NEXT_VERSION=$REPLY
            break
        fi
    done
fi

sed -i -e "s|^\\s*__version__\\s*=\\s*['\"]$CURRENT_VERSION['\"]\\s*$|__version__ = '$NEXT_VERSION'|g" "$INIT_DOT_PY"

#
# All done:-) 
#

exit 0
