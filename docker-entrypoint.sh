#!/usr/bin/env sh
set -euo pipefail

SKIP_OLD_FILES=false

# Loop through arguments and process them
for arg in "$@"; do
    case $arg in
    --skip-old-files)
        SKIP_OLD_FILES=true
        shift # Remove --skip-verification from `$@`
        ;;
    *)
        break
        ;;
    esac
done

if ! [ -e index.php -a -e inc/class_core.php ]; then
	echo >&2 "MyBB not found in $PWD - copying now..."
	if [[ $SKIP_OLD_FILES == true ]]; then
		echo >&2 "Preserving existing directory files..."
		tar cf - --one-file-system -C /usr/src/mybb-mybb_${MYBB_VERSION} . | tar xf - --skip-old-files
	else
		if [ "$(ls -A)" ]; then
			echo >&2 "WARNING: $PWD is not empty - press Ctrl+C now if this is an error!"
			( set -x; ls -A; sleep 10 )
		fi
		tar cf - --one-file-system -C /usr/src/mybb-mybb_${MYBB_VERSION} . | tar xf -
	fi
	echo >&2 "Complete! MyBB ${MYBB_VERSION} has been successfully copied to $PWD"
fi

exec "$@"
