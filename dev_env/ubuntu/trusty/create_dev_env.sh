#
# this script is expected to be invoked by a shell script
# that looks something like this
#
#   #!/usr/bin/env bash
#   curl -s https://raw.githubusercontent.com/simonsdave/dev-env/master/dev_env/ubuntu/trusty/create_dev_env.sh | bash -s "$PWD/provision.sh"
#   exit $?
#

create_dev_env() {

    SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

    GITHUB_USERNAME=''
    until [ "$GITHUB_USERNAME" != "" ]; do
        echo -n "$(tput bold)github username> $(tput sgr0)"
        read GITHUB_USERNAME
    done

    GITHUB_EMAIL=''
    until [ "$GITHUB_EMAIL" != "" ]; do
        echo -n "$(tput bold)github email> $(tput sgr0)"
        read GITHUB_EMAIL
    done

    GITHUB_SSH_PUBLIC_KEY_FILENAME=''
    until [ "$GITHUB_SSH_PUBLIC_KEY_FILENAME" != "" ]; do
        echo -n "$(tput bold)github SSH public key file> $(tput sgr0)"
        read -e GITHUB_SSH_PUBLIC_KEY_FILENAME

        GITHUB_SSH_PUBLIC_KEY_FILENAME=$(python -c "import os.path; print os.path.expanduser('$GITHUB_SSH_PUBLIC_KEY_FILENAME')")

        if [ ! -r "$GITHUB_SSH_PUBLIC_KEY_FILENAME" ]; then
            echo "Can't read SSH public key file '$GITHUB_SSH_PUBLIC_KEY_FILENAME'"
            continue
        fi
    done

    GITHUB_SSH_PRIVATE_KEY_FILENAME=''
    until [ "$GITHUB_SSH_PRIVATE_KEY_FILENAME" != "" ]; do
        echo -n "$(tput bold)github SSH private key file> $(tput sgr0)"
        read -e GITHUB_SSH_PRIVATE_KEY_FILENAME

        GITHUB_SSH_PRIVATE_KEY_FILENAME=$(python -c "import os.path; print os.path.expanduser('$GITHUB_SSH_PRIVATE_KEY_FILENAME')")

        if [ ! -r "$GITHUB_SSH_PRIVATE_KEY_FILENAME" ]; then
            echo "Can't read SSH private key file '$GITHUB_SSH_PRIVATE_KEY_FILENAME'"
            continue
        fi
    done

    BASE64_ENCODED_GITHUB_SSH_PUBLIC_KEY=$(cat "$GITHUB_SSH_PUBLIC_KEY_FILENAME" | base64)
    BASE64_ENCODED_GITHUB_SSH_PRIVATE_KEY=$(cat "$GITHUB_SSH_PRIVATE_KEY_FILENAME" | base64)

    pushd $(mktemp -d 2> /dev/null || mktemp -d -t DAS) >& /dev/null

    VAGRANT_GITHUB_USERNAME=$GITHUB_USERNAME \
        VAGRANT_GITHUB_EMAIL=$GITHUB_EMAIL \
        VAGRANT_BASE64_ENCODED_GITHUB_SSH_PUBLIC_KEY=$BASE64_ENCODED_GITHUB_SSH_PUBLIC_KEY \
        VAGRANT_BASE64_ENCODED_GITHUB_SSH_PRIVATE_KEY=$BASE64_ENCODED_GITHUB_SSH_PRIVATE_KEY \
        vagrant up

    return $?
}

pushd $(mktemp -d 2> /dev/null || mktemp -d -t DAS) >& /dev/null
# :TODO: reminder to find a way to eliminate the hard coded URL
# and in particular the branch from the URL
curl -s --output Vagrantfile "https://raw.githubusercontent.com/simonsdave/dev-env/master/dev_env/ubuntu/trusty/Vagrantfile"
cp "${1:-}" "./provision.sh"
create_dev_env
exit $?
