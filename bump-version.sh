#!/bin/sh
usage() {
	echo "usage: bump-version <version-id>"
}

if [ $# -ne 1 ]; then
	usage
	exit 1
fi

if ! sed 's/^METAFORCE_VERSION=.*$/METAFORCE_VERSION='$1'/g' metaforce-version > .metaforce-version.new; then
	echo "Could not replace METAFORCE_VERSION variable." >&2
	exit 2
fi

mv .metaforce-version.new metaforce-version
git add metaforce-version
git commit -m "Bumped version number to $1" metaforce-version