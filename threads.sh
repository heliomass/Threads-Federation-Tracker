#!/usr/bin/env bash

set -o nounset
set -o errexit

#######################################################################
#
# Threads Federation Tracker
#
# By Daniel Demby
# https://heliomass.com
#
#######################################################################

# Absolute path to this script
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# Location of the CSV file to read in
CSV=

# Help screen
display_help() {

	echo 'Run this script with the --csv argument, providing the path to a valid CSV file.'

}

# Parse command arguments
while [ $# -gt 0 ]; do
	case "$1" in
		--csv)
			CSV="$2"
			if ! [[ -f "$CSV" ]]; then
				echo "$CSV could not be located." >&2
				exit 1
			fi
			shift 2
			;;
		--help|-h|-?)
			shift 1
			display_help
			exit 0
			;;
		--debug)
			echo '+ Debug mode'
			set -o xtrace
			shift 1
			;;
		*)
			echo "Unrecognised paramter ${1}. Please use the --help switch to see usage." >&2
			exit 1
			;;
	esac
done

# Ensure a CSV file was provied
if [[ -z "$CSV" ]]; then
	echo 'Please provide an argument to --csv' >&2
	exit 1
fi

file_suffix="$(date '+%Y%m%d')"
file_name="threads_accounts_${file_suffix}.csv"
count=0

# Process each account in the CSV file and build a new CSV file as output
while read -r line; do
	acct="$(echo -n "$line" | sed 's/,.*//' | xargs)"
	echo -n "$acct,"
	url="https://threads.net/.well-known/webfinger?resource=acct:${acct}@threads.net"
	resp_code=$(curl -o /dev/null -s -w "%{http_code}\n" "$url")
	result="ERROR"
	if [[ "$resp_code" == "200" ]]; then
		result="FEDERATED"
	elif [[ "$resp_code" == "404" ]]; then
		result="NOT FEDERATED"
	fi
	echo "$result"
	count=$((count+1))
done < "$CSV" > "$file_name"

# Done!
echo "${count} accounts were processed and written to ${file_name}"

