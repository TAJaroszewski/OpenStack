#!/bin/bash
# TJAROSZEWSKI@MIRANTIS.COM [ 26.08.2014 ]

prog=$(basename $0);
SQL_SHOW="select ip_address from ipallocations";

declare -A LIST=`mysql -N -L -s -u neutron -pPASSWORD -e "${SQL_SHOW}" neutron`;
if [ $? -ne 0 ]; then
	echo "ERROR: GATEWAY CHECKER - Cannot connect to neutron db";
fi

# TEST 
# declare -A LIST="192.168.56.0/30 192.168.56.254";
INVALID_IPS="192.168.200.1 192.168.201.1";

for ips in "${!LIST[@]}"; do echo "${LIST["$ips"]}"; done | \
	while read gw; do
		#echo GATEWAY: ${gw};
		if [ ${gw} != "NULL" ]; then
			for inv in $INVALID_IPS; do
				if [ $inv == $gw ]; then
					echo "ERROR: $gw is present";
				fi
			done	
		fi
#		printsubnet "${addr}";
	done
exit 0;
#EOF

