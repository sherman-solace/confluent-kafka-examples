#!/bin/bash

USE_EXTERNAL=${1}
# Source library
source ../utils/ccloud_library.sh
source ../utils/helper.sh

# source ./local-env.sh

export CONFIG_FILE=stack-configs/stack.config

#    if [[ -z "$CONFIG_FILE" ]]; then
#      mkdir -p stack-configs
#      CONFIG_FILE="stack-configs/java-service-account-$SERVICE_ACCOUNT_ID.config"
#    fi

if [[ -n "$USE_EXTERNAL" ]]; then
  KAFKA_ENDPOINT=${BOOTSTRAP_SERVERS}
  SCHEMA_REGISTRY_ENDPOINT=${SCHEMA_REGISTRY_URL}
  KSQLDB_ENDPOINT=${KSQLDB_INTERNAL_ENDPOINT}
else
  KAFKA_ENDPOINT=${KAFKA_EXTERNAL_SERVERS}
  SCHEMA_REGISTRY_ENDPOINT=${SCHEMA_REGISTRY_EXTERNAL_URL}
  KSQLDB_ENDPOINT=${KSQLDB_EXTERNAL_ENDPOINT}
fi
cat <<EOF > $CONFIG_FILE
# --------------------------------------
# Confluent Cloud connection information
# --------------------------------------
# ENVIRONMENT_ID=${ENVIRONMENT}
# SERVICE_ACCOUNT_ID=${SERVICE_ACCOUNT_ID}
# KAFKA_CLUSTER_ID=${CLUSTER}
# SCHEMA_REGISTRY_CLUSTER_ID=${SCHEMA_REGISTRY}
# KSQLDB APP ID: ${KSQLDB}
# --------------------------------------
sasl.mechanism=PLAIN
security.protocol=PLAINTEXT
bootstrap.servers=${KAFKA_ENDPOINT}
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username='${CLOUD_API_KEY}' password='${CLOUD_API_SECRET}';
basic.auth.credentials.source=USER_INFO
schema.registry.url=${SCHEMA_REGISTRY_ENDPOINT}
basic.auth.user.info=`echo $SCHEMA_REGISTRY_CREDS | awk -F: '{print $1}'`:`echo $SCHEMA_REGISTRY_CREDS | awk -F: '{print $2}'`
replication.factor=${REPLICATION_FACTOR}
ksql.endpoint=${KSQLDB_ENDPOINT}
ksql.basic.auth.user.info=`echo $KSQLDB_CREDS | awk -F: '{print $1}'`:`echo $KSQLDB_CREDS | awk -F: '{print $2}'`
EOF
echo
echo "Client configuration file saved to: $CONFIG_FILE"

printf "\n====== Generating Confluent Cloud configurations\n"
ccloud::generate_configs $CONFIG_FILE
