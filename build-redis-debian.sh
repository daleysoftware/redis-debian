#!/bin/bash -e

#
# Functions
#

usage()
{
    echo "Usage: $0 <name> <version> <desc> <repo>"
}

#
# Check options
#

if [ $# -ne 4 ]
then
    usage
    exit 1
fi

name=$1
version=$2
desc=$3
repo=$4

if [ ! -d "$repo" ]
then
    echo "Error: \"$repo\" does not exist."
    usage
    exit 1
fi

if [ ! -f "$repo/Makefile" ]
then
    echo "No Makefile in \"$repo\". Are you sure that's where redis is located?"
    usage
    exit 2
fi

if [ -z "$name" ]
then
    echo "Must supply non-zero length debian name."
    usage
    exit 3
fi

if [ -z "$version" ]
then
    echo "Must supply valid version number."
    usage
    exit 4
fi

#
# Build redis and populate
#

echo "Building redis..."

cwd=$(pwd)
cd "$repo"
make 1>/dev/null 2>/dev/null
cd $cwd

#
# Create the actual debian
#

echo "Building debian..."

mkdir -p src/usr/bin

for e in benchmark check-aof check-dump cli server
do
    cp "$repo"/src/redis-$e src/usr/bin
done

if [ ! -z "$desc" ]
then
    echo "  $desc" >> src/DEBIAN/control
fi
echo "Package: $name" >> src/DEBIAN/control
echo "Version: $version" >> src/DEBIAN/control

dpkg-deb --build src $name-$version.deb

#
# Closing remarks and cleanup
#

git checkout -- src/DEBIAN/control
echo "Your debian is ready! Enjoy!"
