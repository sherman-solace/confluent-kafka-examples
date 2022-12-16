#!/bin/bash

# set -e

TOPICS_FILE=$1
BOOTSTRAP_SERVERS=${2:-"broker:9092"}
PARTITIONS=${PARTITIONS:-1}
REPLICATION_FACTOR=${REPLICATION_FACTOR:-1}

# cat $TOPICS_FILE

# blocks until kafka is reachable
echo '=============== Topics before ==============='
CURRENT_TOPICS=$($CONTAINER_ENGINE exec kafka kafka-topics --bootstrap-server $BOOTSTRAP_SERVERS --list)
echo "$CURRENT_TOPICS"

while IFS= read -r TOPIC; 
  do
    # printf "\nProcessing topic $TOPIC\n"
    [[ -z "$TOPIC" ]] || {
#      TOPIC_EXISTS=$(jq "map(select(.name == \"$TOPIC\")) | length" <<< "$CURRENT_TOPICS")
      TOPIC_EXISTS=$(echo "$CURRENT_TOPICS" | grep "$TOPIC")
#      echo "$TOPIC exists: <$TOPIC_EXISTS>"
      if [[ ! -z $TOPIC_EXISTS ]]; then
        printf "topic $TOPIC already exists\n"
      else
        printf "\nCreating topic $TOPIC\n"
        $CONTAINER_ENGINE exec kafka kafka-topics --create --bootstrap-server $BOOTSTRAP_SERVERS --partitions $PARTITIONS --replication-factor $REPLICATION_FACTOR --topic $TOPIC $ADDITIONAL_ARGS
      fi
    }
  done <$TOPICS_FILE

echo '===============Topics are now:==========================='
podman exec kafka kafka-topics --bootstrap-server $BOOTSTRAP_SERVERS --list
