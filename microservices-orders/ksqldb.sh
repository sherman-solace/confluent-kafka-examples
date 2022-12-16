#!/bin/bash

################################

STATEMENT_FILE="$1"
KSQLDB_ENDPOINT=${2:-http://localhost:8088}


KQLDB_QUERY_PROPERTIES='"ksql.streams.auto.offset.reset":"earliest","ksql.streams.cache.max.bytes.buffering":"0"'

while IFS= read -r ksqlCmd; do

  cmdStr="${ksqlCmd}"
  echo
  echo $cmdStr
#       -u $KSQLDB_BASIC_AUTH_USER_INFO \
  response=$(curl -X POST $KSQLDB_ENDPOINT/ksql \
       -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" \
       --silent \
       -d @<(cat <<EOF
{
  "ksql": $cmdStr ,
  "streamsProperties": { $KQLDB_QUERY_PROPERTIES }
}
EOF
))
  printf "\n$response\n"
#  if [[ ! "$response" =~ "SUCCESS" ]]; then
#		if [[ ! "$response" =~ "already exists" ]]; then
##    	echo -e "\nERROR: KSQL command '$ksqlCmd' did not include \"SUCCESS\" in the response.  Please troubleshoot.\n"
#    	# exit 1
#		fi
#  fi
done < $STATEMENT_FILE
