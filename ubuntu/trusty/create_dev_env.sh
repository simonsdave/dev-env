#
# this script is expected to be invoked by a shell script
# that looks something like this
#
#   #!/usr/bin/env bash
#   curl -s https://raw.githubusercontent.com/simonsdave/dev-env/master/ubuntu/trusty/create_dev_env.sh | bash -s -- "$PWD/provision.sh" "$@"
#   exit $?
#

pushd $(mktemp -d 2> /dev/null || mktemp -d -t DAS) >& /dev/null
# :TODO: reminder to find a way to eliminate the hard coded URL
# and in particular the branch from the URL
curl -s --output Vagrantfile "https://raw.githubusercontent.com/simonsdave/dev-env/master/ubuntu/trusty/Vagrantfile"
cp "${1:-}" "./provision.sh"

if [ ! -r "${4:-}" ]; then
    echo "Can't read SSH public key file '${4:-}'"
    exit 1
fi
BASE64_ENCODED_GITHUB_SSH_PUBLIC_KEY=$(cat "${5:-}" | base64)

if [ ! -r "${5:-}" ]; then
    echo "Can't read SSH private key file '${5:-}'"
    exit 1
fi
BASE64_ENCODED_GITHUB_SSH_PRIVATE_KEY=$(cat "${4:-}" | base64)

VAGRANT_GITHUB_USERNAME=${2:-} \
    VAGRANT_GITHUB_EMAIL=${3:-} \
    VAGRANT_BASE64_ENCODED_GITHUB_SSH_PUBLIC_KEY=$BASE64_ENCODED_GITHUB_SSH_PUBLIC_KEY \
    VAGRANT_BASE64_ENCODED_GITHUB_SSH_PRIVATE_KEY=$BASE64_ENCODED_GITHUB_SSH_PRIVATE_KEY \
    vagrant up

exit $?
