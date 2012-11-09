#!/usr/bin/env zsh

typeset -A probes
typeset -a targets

graph=$1

if [[ ! -r ${graph} ]] ; then
	echo "usage: "
	echo "$0 file.graph"
	exit 1
fi

source $graph

height=${height:-800}
width=${width:-400}
from=${from:-24h}
to=${to:-now}

if [[ -z "${formula}" || -z "${baseurl}" || -z "${probes}" ]] ; then
	echo "One of following variable is empty: formula, baseurl, probes"
	exit 1
fi

for probe in ${(k)probes}
do
	target=${formula//@probe@/$probes[$probe]}
	target=${target//@title@/$probe}
	targets+=$target
done

URL="${baseurl}/render?width=${width}&height=${height}&from=${from}&until=${to}"
for target in $targets
do
	URL+="&target=${target}"
done

print $URL
