#!/bin/sh
# TJAROSZEWSKI@MIRANTIS [20.07.2014]
# Script verify availability of dhcp servers in namespaces

export LC_ALL=C;

RETURNCODE=0;
Q_NUM=0;
Q_NUM_TOTAL=0;

QROUTERS_ARRAY=`ip netns ls | grep -i qdhcp`;
if [ $? -eq 0 ]; then
        if [ -n "$QROUTERS_ARRAY" ]; then

	for LIST in $QROUTERS_ARRAY; do
                # CHECKING SIZE of QROUTER;
                Q_SIZE=`echo $LIST | wc -c`;
                if [ $Q_SIZE -eq 43 ]; then
			Q_NUM_TOTAL=$(($Q_NUM_TOTAL+1));
                        ip netns exec $LIST \
			lsof -P -i :67 | grep -q ':67' && Q_NUM=$((Q_NUM+1)) || echo MISSING: $LIST;
		else
			echo "UNKNOWN: SIZE of DHCP does not match 45 chars";
			exit 1;
                fi
        done
	else
		echo "UNKNOWN: No DHCP present";
		exit 1;
        fi
else
	echo "UNKNOWN: IP Netns command failure OR No DHCP present";
	exit 2;
fi

echo Q_NUM: $Q_NUM;
echo Q_NUM_TOTAL: $Q_NUM_TOTAL;

if [ $Q_NUM -ne $Q_NUM_TOTAL ]; then
	echo "ERROR: $(($Q_NUM_TOTAL-$Q_NUM)) DHCP server/s is/are offline";
	RETURNCODE=1;
else
	echo "OK: All DHCP instances are running";
	RETURNCODE=0;
fi

exit $RETURNCODE;
# EOF
