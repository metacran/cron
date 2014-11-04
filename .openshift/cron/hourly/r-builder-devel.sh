#! /bin/bash

# ----------------------------------------------------------
# Use etags to decide if we need to build

ETAGFILE="/tmp/r-builder-etag.txt"

old_etag=""

if [ -f "$ETAGFILE" ]; then
    old_etag=$(cat "$ETAGFILE")
fi

etag=$(curl -I -s http://svn.r-project.org/R/ -X HEAD |
	      grep ETag | cut -f2 -d" ")

if [ "$etag" == "$old_etag" ]; then
    exit 0;
fi;

echo $etag > "$ETAGFILE"

svnrev=$(echo $etag | cut -f2 -d/ | tr -dC '0-9')

# ----------------------------------------------------------
# Need to set up the Github token first

cd /tmp
rm -rf r-builder
trap "rm -rf /tmp/r-builder" SIGINT SIGTERM

git clone -b travis-devel --single-branch \
    https://github.com/metacran/r-builder.git
cd r-builder
git fetch origin semaphore-devel:refs/remotes/origin/semaphore-devel

git config user.name "Gabor Csardi"
git config user.email "csardi.gabor@gmail.com"
git config push.default matching

git config credential.helper "store --file=.git/credentials"
python -c 'import os; print "https://" + os.environ["RBUILDER_TOKEN"] + ":@github.com"' \
       > .git/credentials

# ----------------------------------------------------------
# Ping Travis by doing a forced push

git checkout travis-devel
git commit --allow-empty -m "Update R-devel for Travis, $svnrev"
git push origin travis-devel

git checkout semaphore-devel
git commit --allow-empty -m "Update R-devel for Semaphore, $svnrev"
git push origin semaphore-devel

# ----------------------------------------------------------
# Clean up

rm -rf /tmp/r-builder
