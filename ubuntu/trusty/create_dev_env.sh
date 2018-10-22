#!/usr/bin/env bash
#
# this script is expected to be invoked by a shell script
# that looks something like this
#
#   #!/usr/bin/env bash
#   curl -s https://raw.githubusercontent.com/simonsdave/dev-env/release-0.5.6/ubuntu/trusty/create_dev_env.sh | bash -s -- "$@"
#   exit $?
#
# to test
#
#   curl -s file://create_dev_env.sh | bash -s --
#

set -e

MEMORY_IN_MB=2048
NGINX_PORT=0
TIMEZONE=EST

while true
do
    # note - was using "${1,,}" so command line args where not case sensitive
    # but was getting "bad substitution" errors on
    #
    #    GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin15)
    #
    # which is why reverted to using the sub-optimal "${1:-}"
    case "${1:-}" in
        --memory)
            shift
            MEMORY_IN_MB=${1:-}
            shift
            ;;
        --nginx)
            shift
            NGINX_PORT=${1:-}
            shift
            ;;
        --timezone)
            shift
            TIMEZONE=${1:-EST}
            shift
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 4 ]; then
    echo "usage: $(basename "$0") [--memory <MB>|--nginx <port>|--timezone <timezone>] <github username> <github email> <github public key> <github private key>" >&2
    exit 1
fi

if [ ! -r "provision.sh" ]; then
    echo "Can't read 'provision.sh'"
    exit 1
fi

curl -s --output Vagrantfile "https://raw.githubusercontent.com/simonsdave/dev-env/release-0.5.6/ubuntu/trusty/Vagrantfile"

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
    VAGRANT_MEMORY_IN_MB=$MEMORY_IN_MB \
    VAGRANT_NGINX_PORT=$NGINX_PORT \
    VAGRANT_TIMEZONE=$TIMEZONE \
    vagrant up

# cleanup: would normally remove previously curl'ed Vagrantfile
# but vagrant does not respond well if that's done:-(

exit $?
