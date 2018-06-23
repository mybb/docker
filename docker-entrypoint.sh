#!/usr/bin/env bash
set -euo pipefail

if ! [ -e index.php -a -e inc/class_core.php ]; then
	echo >&2 "MyBB not found in $PWD - copying now..."
	if [ "$(ls -A)" ]; then
		echo >&2 "WARNING: $PWD is not empty - press Ctrl+C now if this is an error!"
		( set -x; ls -A; sleep 10 )
	fi
	git clone -b develop/1.9 https://github.com/mybb/mybb $PWD
	echo >&2 "Complete! MyBB ${MYBB_VERSION} has been successfully cloned to $PWD"
	touch inc/config.php
	chmod 666 inc/config.php inc/settings.php
	chmod 777 cache/ cache/themes/ uploads/ uploads/avatars/
	chmod 666 inc/languages/english/*.php inc/languages/english/admin/*.php
	chmod 777 cache/ cache/themes/ uploads/ uploads/avatars/ admin/backups/
fi

exec "$@"
