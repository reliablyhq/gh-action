#!/bin/bash
set -e

# This script takes two positional arguments. The first is the version of Reliably to install.
# This can be a standard version (ie. v1.2.3) or it can be latest, in which case the
# latest released version will be used.
#
# The second argument is the platform, in the format used by the `runner.os` context variable
# in GitHub Actions. Note that this script does not currently support Windows based environments.
#
# As an example, the following would install the latest version of Reliably for GitHub Actions for
# a Linux runner:
#
#     ./setup_reliably.sh latest Linux
#

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "Setup Reliably requires two argument, $# provided"

echo "Installing the $1 version of Reliably on $2"

if [ "$1" == "latest" ]; then
    URL="https://api.github.com/repos/reliablyhq/cli/releases/${1}"
else
    URL="https://api.github.com/repos/reliablyhq/cli/releases/tags/${1}"
fi

case "$2" in
    Linux)
        PREFIX="linux-amd64"
        ;;
    Windows)
        die "Windows runner not currently supported"
        ;;
    macOS)
        PREFIX="darwin-amd64"
        ;;
    *)
        die "Invalid running specified: $2"
esac

wget -qO- ${URL} | grep "browser_download_url" | grep  ${PREFIX} | cut -d '"' -f 4 | wget --progress=bar:force:noscroll -i -

case "$2" in
    Linux)
        md5sum -c reliably-${PREFIX}.md5
        ;;
    macOS)
        echo "Unable to check downloaded binary md5 on macOS"
        ;;
esac

chmod +x reliably-${PREFIX}
sudo mv reliably-${PREFIX} /usr/local/bin/reliably
