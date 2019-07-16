#!/usr/bin/env bash

cd "$(dirname "$0")"

if [ -f .env ]; then
	export $(cat .env | sed 's/#.*//g' | xargs)
fi

LOCKFILE=".lock"

if [ -f "$LOCKFILE" ] && kill -0 "$(cat $LOCKFILE)" 2>/dev/null; then
	echo "Updating"
	exit 1
fi

echo $$ > $LOCKFILE

git pull

$UPDATER

git add -A
git commit --no-gpg-sign -a -m "Updated: $(date +"%Y-%m-%d %T %:z")"
git push

rm $LOCKFILE
