#!/usr/bin/env bash
#
# this script is expected to be invoked by a shell script
# that looks something like this
#
#   #!/usr/bin/env bash
#   curl -s https://raw.githubusercontent.com/simonsdave/dev-env/master/ubuntu/trusty/create_dev_env.sh | bash -s -- "$@"
#   exit $?
#
# to test
#
#   curl -s file://create_dev_env.sh | bash -s --
#

if [ $# != 4 ]; then
    echo "usage: $(basename "$0") <github username> <github email> <github public key> <github private key>" >&2
    exit 1
fi

if [ ! -r "provision.sh" ]; then
    echo "Can't read 'provision.sh'"
    exit 1
fi

# :TODO: reminder to find a way to eliminate the hard coded URL
# and in particular the branch from the URL
curl -s --output Vagrantfile "https://raw.githubusercontent.com/simonsdave/dev-env/master/ubuntu/trusty/Vagrantfile"

if [ ! -r "${3:-}" ]; then
    echo "Can't read SSH public key file '${3:-}'"
    exit 1
fi
BASE64_ENCODED_GITHUB_SSH_PUBLIC_KEY=$(base64 < "${3:-}")

if [ ! -r "${4:-}" ]; then
    echo "Can't read SSH private key file '${4:-}'"
    exit 1
fi
BASE64_ENCODED_GITHUB_SSH_PRIVATE_KEY=$(base64 < "${4:-}")

VAGRANT_GITHUB_USERNAME=${1:-} \
    VAGRANT_GITHUB_EMAIL=${2:-} \
    VAGRANT_BASE64_ENCODED_GITHUB_SSH_PUBLIC_KEY=$BASE64_ENCODED_GITHUB_SSH_PUBLIC_KEY \
    VAGRANT_BASE64_ENCODED_GITHUB_SSH_PRIVATE_KEY=$BASE64_ENCODED_GITHUB_SSH_PRIVATE_KEY \
    vagrant up

# cleanup: would normally remove previously curl'ed Vagrantfile
# but vagrant does not respond well if that's done:-(

exit $?
