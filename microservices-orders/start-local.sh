#!/bin/bash

source ../utils/helper.sh

check_connect_up_podman() {
  containerName=$1

  FOUND=$(podman-compose logs $containerName | grep "Herder started")
  if [ -z "$FOUND" ]; then
    return 1
  fi
  return 0
}


host_check_ksqlDBserver_running()
{
  KSQLDB_CLUSTER_ID=$(curl -s http://localhost:8088/info | jq -r ".KsqlServerInfo.serverStatus")
  if [ "$KSQLDB_CLUSTER_ID" == "RUNNING" ]; then
    return 0
  fi
  return 1
}

source ./local-env.sh

export CONFIG_FILE=stack-configs/stack.config

WARMUP_TIME=${WARMUP_TIME:-80}

source ./gen-configs.sh local

DELTA_CONFIGS_DIR=delta_configs
source $DELTA_CONFIGS_DIR/env.delta

printf "\n====== Creating demo topics\n"
./create-topics.sh ./topics.txt $BOOTSTRAP_SERVERS

# needed for elasticsearch to start
sysctl -w vm.max_map_count=262144

printf "\n====== Starting app with podman-compose\n"
$CONTAINER_ENGINE-compose -f docker-compose-local.yml up -d  --build

printf "\n====== Giving services $WARMUP_TIME seconds to startup\n"
sleep $WARMUP_TIME
MAX_WAIT=240
echo "Waiting up to $MAX_WAIT seconds for connect to start"
retry $MAX_WAIT check_connect_up_podman connect || exit 1
printf "\n\n"

printf "\n====== Configuring Elasticsearch mappings\n"
./dashboard/set_elasticsearch_mapping.sh

printf "\n====== Submitting connectors\n\n"
printf "====== Submitting Kafka Connector to source customers from sqlite3 database and produce to topic 'customers'\n"
INPUT_FILE=./connectors/connector_jdbc_customers_template.config 
OUTPUT_FILE=./connectors/rendered-connectors/connector_jdbc_customers.config 
SQLITE_DB_PATH=/opt/docker/db/data/microservices.db
source ./scripts/render-connector-config.sh 
curl -s -S -XPOST -H Accept:application/json -H Content-Type:application/json $CONNECTORS_EXTERNAL_URL/connectors/ -d @$OUTPUT_FILE

printf "\n\n====== Submitting Kafka Connector to sink records from 'orders' topic to Elasticsearch\n"
INPUT_FILE=./connectors/connector_elasticsearch_template.config
OUTPUT_FILE=./connectors/rendered-connectors/connector_elasticsearch.config 
ELASTICSEARCH_URL=$ELASTIC_URL
source ./scripts/render-connector-config.sh
curl -s -S -XPOST -H Accept:application/json -H Content-Type:application/json $CONNECTORS_EXTERNAL_URL/connectors/ -d @$OUTPUT_FILE

printf "\n====== Validating and setting up ksqlDB App\n"

MAX_WAIT_KSQLDB=720
printf "\n====== Waiting up to $MAX_WAIT_KSQLDB for ksqlDB to be ready\n"
retry $MAX_WAIT_KSQLDB host_check_ksqlDBserver_running  || exit 1
# $KSQLDB_ENDPOINT
#ccloud::validate_ccloud_ksqldb_endpoint_ready

printf "\n====== Creating ksqlDB STREAMS and TABLES\n"
./ksqldb.sh ./statements-ccloud.sql $KSQLDB_EXTERNAL_ENDPOINT

printf "\n\n====== Configuring Kibana Dashboard\n"
./dashboard/configure_kibana_dashboard.sh

printf "\n\n====== Reading data from topics and ksqlDB\n"
./read-topics.sh

